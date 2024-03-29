#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd -P`
popd > /dev/null

reqs_changed() {
  echo Requirements have changed
  echo New MD5sum:
  cat requirements/base.txt requirements/test.txt | md5sum
}

(cat requirements/base.txt requirements/test.txt | md5sum --quiet -c $SCRIPTPATH/requirements.md5sum) || reqs_changed
echo Requirements still OK

HERED=$SCRIPTPATH/*-*
LIST=""

for fn in $HERED; do
  LIST="$LIST file://$fn"
done

pip install --no-deps $LIST
pip install -r requirements/test.txt --index-url=http://simple.crate.io/
