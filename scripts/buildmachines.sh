#!/bin/bash

numnodes=20000 # realistic value

# keys from properties file
buildmachineip="build.machine.ip."
buildmachineusername="build.machine.username."
buildmachinepassword="build.machine.password."
buildmachinename="build.machine.name."
buildmachineenv="build.machine.environment."
buildmachinerunlist="build.machine.runlist."

if [ $# -lt 1 ]; then
  echo "Invalid argument! Properties file missing. Please provide input arguments in format : ./$0 <properties_file_fully_qualified_name>. Failed to bootstrap build machines. Exiting..."
  exit 1;
fi

propfile=$1

echo "Bootstraping build machines..."

for (( i=1 ; i<=$numnodes ; i++ )); do
  buildmachineip="build.machine.ip."
  buildmachineusername="build.machine.username."
  buildmachinepassword="build.machine.password."
  buildmachinename="build.machine.name."
  buildmachineenv="build.machine.environment."
  buildmachinerunlist="build.machine.runlist."
  
  buildmachineip=$(cat $propfile | grep -m 1 "$buildmachineip$i" | cut -d "=" -f2)
  if [ -z $buildmachineip ]; then
    i=$numnodes # no next values present, end loop
  else 
    buildmachineusername=$(cat $propfile | grep -m 1 "$buildmachineusername$i" | cut -d "=" -f2)
    buildmachinepassword=$(cat $propfile | grep -m 1 "$buildmachinepassword$i" | cut -d "=" -f2)
    buildmachinename=$(cat $propfile | grep -m 1 "$buildmachinename$i" | cut -d "=" -f2)
    buildmachineenv=$(cat $propfile | grep -m 1 "$buildmachineenv$i" | cut -d "=" -f2)
    buildmachinerunlist=$(cat $propfile | grep -m 1 "$buildmachinerunlist$i" | cut -d "=" -f2)
  fi

  if [ ! -z $buildmachineip ]; then
    /bin/bash ./bootstrapnode.sh $buildmachineip $buildmachineusername $buildmachinepassword $buildmachinename
    if [ $? != 0 ]; then
      echo "Failed to Bootstrap build machine node : $buildmachineip . Exiting..."
      exit 1
    else
      echo "Node $buildmachineip bootstrapped successfully."
    fi

    /bin/bash ./assignrunlist.sh $buildmachinename $buildmachineenv $buildmachinerunlist
    if [ $? != 0 ]; then
      echo "Failed to assign runlist to Build Machine $buildmachinename . Exiting..."
      exit 1
    else
      echo "Run List assigned successfully to Build Machine $buildmachinename ."
    fi
  fi
done

echo "Build Machines Bootstrap complete."
