#!/bin/bash

if [ ! -f module.xml ]; then
  echo "File module.xml does not exists"
  exit 1
fi

MODULE=`grep -oP '<Name>\K([^<]+)' module.xml`
MODULE=${MODULE,,}
VERBOSE=`[[ $INPUT_VERBOSE == 1 ]] && echo '-v'`

ZPM_TEST=`[[ ${INPUT_TEST:-1} == 1 ]] && echo "zpm \"$MODULE test $VERBOSE\":1"`
ZPM_VERIFY=`[[ ${INPUT_VERIFY:-1} == 1 ]] && echo "zpm \"$MODULE verify $VERBOSE\":1"`

iris start $ISC_PACKAGE_INSTANCENAME quietly
 
cat << EOF | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS
zpm "load ""$PWD"" $VERBOSE":1
$ZPM_TEST
$ZPM_VERIFY
halt
EOF

exit=$?

iris stop $ISC_PACKAGE_INSTANCENAME quietly

exit $exit