#!/usr/bin/env bash
echo "Starting with cleanup ..."

repoName=${1}
hostName=$(echo $(hostname) | cut -d. -f1)

if [ $# -eq 0 ]
then
   repoName="qa"
fi

echo "Enabling $repoName repo with database $hostName....."
scriptPath=$(pwd)

cd /opt/gls/clarity/bin
./run_clarity.sh stop
cd /etc/init.d
./nextseq_seqservice-v1 stop
./nextseq_seqservice-v2 stop

unalias rm
unalias mv

echo "Removing PreReq..."
yum list | grep PreReq
echo y| yum remove "*PreReqs*"

echo "Removing Elastic.."
echo y | yum remove "elasticsearch"

echo y | yum remove "rabbitmq-server"

rm -rf /opt/gls/clarity
rm -rf /opt/gls/jdk8
rm -rf /opt/gls/jdk6
rm -rf /var/log/elasticsearch/*
rm -rf /opt/elasticsearch

echo "Deleting and Creating users and groups"
userdel -rf glsai
userdel -rf glsftp
userdel -rf glsjboss
userdel -rf glstomcat
groupdel claritylims
groupdel glsjdk6
groupdel glsjdk7
groupdel glsjdk8

echo "Dropping databases tenants. Once prompt, type tenant, proteo, tenant, proteo"


dbName=$hostName
echo "dbName:$dbName"

psql -U postgres -c 'drop database "tenantLookupDB"'
psql -U postgres -c 'create database "tenantLookupDB"'
psql -U postgres -c 'Alter database "tenantLookupDB" Owner to tenant'

psql -U postgres -c 'drop database '$dbName''
psql -U postgres -c 'create database '$dbName''
psql -U postgres -c 'Alter database '$dbName' Owner to proteo'

psql -U postgres -c "Alter user tenant with password 'tenant'"
psql -U postgres -c "Alter user proteo with password 'proteo'"

echo "[runc] Enabling $repoName repo with postgres database $hostName..."
enable_repo.sh -o -r $repoName

echo "[runc] Installing ClarityLIMS-APP...."
echo y | yum install ClarityLIMS-App
pwd
echo "[runc] Clarity LIMS App has been installed!"

cd /opt/gls/clarity/config
rm -f run_pending.sh
pendingFile="$scriptPath/run_pending.sh"
echo "scriptPath=[$scriptPath]. pendingFile=[$pendingFile]"
cp $pendingFile .

echo "Initial cleanup and setup completed! $repoName is enabled with postgres database $hostName. Pending scripts will be installed."


myhost=$(hostname)
rm 20_input.txt

touch 20_input.txt
echo "2" >> 20_input.txt             # Choose DB type as 2 : Postgres
echo $myhost >> 20_input.txt
echo "5432" >> 20_input.txt
echo "tenantLookupDB" >> 20_input.txt
echo "tenant" >> 20_input.txt
echo "tenant" >> 20_input.txt
echo "tenant" >> 20_input.txt


su glsjboss "./pending/20_configure_claritylims_platform.sh" <20_input.txt
echo "[20] Claritylims platform has been configured."
rm 20_input.txt

touch 26_input.txt
echo $myhost >> 26_input.txt
echo $dbName >> 26_input.txt
echo "proteo" >> 26_input.txt
echo "proteo" >> 26_input.txt
echo "proteo" >> 26_input.txt
echo "y" >> 26_input.txt
echo "kszin@illumina.com" >> 26_input.txt
echo "admin" >> 26_input.txt
echo "apassword" >> 26_input.txt
echo "facility" >> 26_input.txt
echo "fpassword" >> 26_input.txt
echo "apiuser" >> 26_input.txt
echo "apipassword" >> 26_input.txt
echo $myhost >> 26_input.txt
echo "/opt/gls/clarity/users/glsftp" >> 26_input.txt
echo "glsftp" >> 26_input.txt
echo "glsftp" >> 26_input.txt
echo "glsftp" >> 26_input.txt
echo "y" >> 26_input.txt
echo "n" >> 26_input.txt

su glsjboss "./pending/26_initialize_claritylims_tenant.sh" < 26_input.txt 
echo "[26] Claritylims_tenant has been initialized."
rm 26_input.txt

touch ftp_input.txt
echo "glsftp" >> ftp_input.txt
echo "glsftp" >> ftp_input.txt
passwd glsftp < ftp_input.txt
rm ftp_input.txt
echo "Gls ftp password has been changed."

rm -f rabbit_input.txt
touch rabbit_input.txt
echo $myhost >> rabbit_input.txt
./pending/32_root_configure_rabbitmq.sh < rabbit_input.txt
echo "Rabbitmq has been installed." 
rm -f rabbit_input.txt

./pending/40_root_install_proxy.sh
echo "Proxy has been installed."

cd /usr/gls/bin
./installQACerts.sh

echo "QA certs installed"
echo "If httpd cannot start by SSL issue, update the file clarity.conf under /etc/httpd/conf.d "
clarityConfig="/etc/httpd/conf.d/clarity.conf"
sed -i 's|CERTPATH/NOT_CONFIGURED_CERT|/etc/httpd/sslcertificate/star_cavc_illumina.com.crt|g' $clarityConfig
sed -i 's|CERTPATH/NOT_CONFIGURED_PRIVATE_KEPT| /etc/httpd/sslcertificate/star_cavc_illumina_com.key|g' $clarityConfig
sed -i 's|# SSLCertificateChainFile CERTPATH/NOT_CONFIGURED_CHAIN|SSLCertificateChainFile /etc/httpd/sslcertificate/chain.crt|g' $clarityConfig
echo "SSL paths have been updated in $clarityConfig"

/opt/gls/clarity/bin/run_clarity.sh start

echo "Going to install QC protocol and NGS package."
printf "y" | yum install "*pre-conf*"

cd /opt/gls/clarity/config
ls -la
su glsjboss -c "./pre-configured-workflows-installer.sh -o install QC_Protocols.base"

yum install ClarityLIMS-NGS-Package*

echo "NGS and QC protocols have been installed."

echo "Clarity is Up! Check at $(hostname)."
