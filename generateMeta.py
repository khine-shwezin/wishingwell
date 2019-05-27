import subprocess
import os

titleFile = "titles.txt"
tempFile = "temp.txt"
resultFile = "result.txt"
reqid = "SRFW02-319"

p = subprocess.Popen("grep \"testEWSSms*\" ../../EWSSmsTest.py >"+titleFile+"", stdout=subprocess.PIPE, shell=True)
(output, err) = p.communicate()

p2 = subprocess.Popen("sed -e 's/def*//' "+titleFile+" | sed -e 's/(self)://g' | sed -e 's/[[:space:]]*//' > "+tempFile+"", stdout=subprocess.PIPE, shell=True)
(output2, err) = p2.communicate()
n = 0
fw = open(resultFile, "wb")

with open(tempFile) as f:
    lines = f.readlines()
    for title in lines:
       title = title.strip("\n\r")
       name = "EWSSmsTest."+title
       n = n + 1
       template = "\"\"\"\n\
$$$$$_BEGIN_TEST_METADATA_DECLARATION_$$$$$\n\
  +purpose:EWS_SMS_TEST\n\
  +test_tier:1\n\
  +is_manual:False\n\
  +version: 1.0\n\
  +test_classification:package\n\
  +reqid:"+reqid+"\n\
  +timeout:120\n\
  +asset:EWS\n\
  +package:webserver_ews\n\
  +test_framework:Staple\n\
  +use_resource_ops_libs:True\n\
  +test_dependencies:webserver/src/webserver_controller/src/validation/btf/ewslib/__init__.py, webserver/src/webserver_controller/src/validation/btf/ewslib/EWSBaseTestLib.py, webserver/src/webserver_controller/src/validation/btf/ewslib/EWSOperationsLib.py, webserver/src/webserver_controller/src/validation/btf/ewslib/EWSSpecOperationsLib.py, webserver/src/webserver_controller/src/validation/btf/ewslib/EWSLEDMOperationsLib.py, webserver/src/webserver_controller/src/validation/btf/ewslib/jsonSMS.json, webserver/src/webserver_controller/src/validation/btf/spec/pagelist.json, webserver/src/webserver_controller/src/validation/btf/ewslib/EWSSMSOperationsLib.py\n\
  +name:"+str(name)+"\n\
  +test:\n\
    +title:"+str(title)+"\n\
    +dut:\n\
      +id:printer-1\n\
      +type:Simulator\n\
$$$$$_END_TEST_METADATA_DECLARATION_$$$$$\n\
\"\"\"\n\
"

       fw.writelines(template)

os.remove(titleFile)
os.remove(tempFile)
fw.close()

print("Completed! Metadata for "+str(n)+" test cases have been created. Check "+resultFile+" in same directory.")