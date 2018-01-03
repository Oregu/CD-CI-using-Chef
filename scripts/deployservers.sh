#!/bin/bash

numnodes=20000 # realistic number

# keys from properties file
deployserverip="deploy.server.ip."
deployserverusername="deploy.server.username."
deployserverpassword="deploy.server.password."
deployservername="deploy.server.name."
deployserverenv="deploy.server.environment."
deployserverrunlist="deploy.server.runlist."

if [ $# -lt 1 ]; then
  echo "Invalid arguments! Properties file missing. Pleae provide input arguments in format : ./$0 <properties_file_fully_qualified_name>. Failed to bootstrap deployment servers. Exiting..."
  exit 1;
fi

propfile=$1

echo "Bootstraping deployment servers..."

for (( i=1 ; i<=$numnodes ; i++ )); do
  deployserverip="deploy.server.ip."
  deployserverusername="deploy.server.username."
  deployserverpassword="deploy.server.password."
  deployservername="deploy.server.name."
  deployserverenv="deploy.server.environment."
  deployserverrunlist="deploy.server.runlist."
  
  deployserverip=$(cat $propfile | grep -m 1 "$deployserverip$i" | cut -d "=" -f2)
  if [ -z $deployserverip ]; then
    i=$numnodes # no next nodes present, end loop
  else
    deployserverusername=$(cat $propfile | grep -m 1 "$deployserverusername$i" | cut -d "=" -f2)
    deployserverpassword=$(cat $propfile | grep -m 1 "$deployserverpassword$i" | cut -d "=" -f2)
    deployservername=$(cat $propfile | grep -m 1 "$deployservername$i" | cut -d "=" -f2)
    deployserverenv=$(cat $propfile | grep -m 1 "$deployserverenv$i" | cut -d "=" -f2)
    deployserverrunlist=$(cat $propfile | grep -m 1 "$deployserverrunlist$i" | cut -d "=" -f2)
  fi

  if [ ! -z $deployserverip ]; then
    /bin/bash ./bootstrapnode.sh $deployserverip $deployserverusername $deployserverpassword $deployservername
    if [ $? != 0 ]; then
      echo "Failed to Bootstrap Deployment server node : $deployserverip . Exiting..."
      exit 1
    else
      echo "Deployment server $deployserverip bootstrapped successfully."
    fi
    
    /bin/bash ./assignrunlist.sh $deployservername $deployserverenv $deployserverrunlist
    if [ $? != 0 ]; then
      echo "Failed to assign runlist to Deployment server $buildmachinename . Exiting..."
      exit 1
    else 
      echo "Run List assigned successfully to Deployment server $buildmachinename ."
    fi
  fi
done

echo "Deployment Servers Bootstrapped complete."
