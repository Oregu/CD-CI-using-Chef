#!/bin/bash

propfile="environment.properties"

if [ $# -eq 1 ]; then
  propfile=$1;
fi
echo "Starting pipeline properties file : $propfile"

if [ -f $propfile ]; then
    echo "Properties file found : $propfile"
else
  echo "Invalid arguments! $propfile file missing. Please provide valid input arguments in format : ./$0 <properties_file_fully_qualified_name>. Exiting with failure..."
  exit 1;
fi

fullyqualifiedpropfilepath=$(pwd)/$propfile
cd ./scripts/.
/bin/bash ./deployservers.sh $fullyqualifiedpropfilepath
if [ $? != 0 ]; then
  echo "Failed to Bootstrap deployment machines. Exiting..."
  exit 1;
fi
/bin/bash ./buildmachines.sh $fullyqualifiedpropfilepath
if [ $? != 0 ]; then
  echo "Failed to Bootstrap build machines. Exiting..."
  exit 1
fi

echo "Done!"
