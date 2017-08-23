#!/bin/bash

echo "Should see this first line"

: <<'kscriptCommentOut'
echo "Should NOT See this line"
echo "Should NOT see this line too"
echo "Should NOT see this line either"
echo ":<< taking the rest as ignorable arguments and do nothing until it sees next kscriptCommentOut"
kscriptCommentOut

echo "Good to see this line back."
