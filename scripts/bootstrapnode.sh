#!/bin/bash

if [ $# -lt 4 ]; then
  echo "Invalid arguments! Please provide inpput arguments in format : ./$0 <node_IP> <node_username> <node_password> <nodename>. Failed to Bootstrap node. Exiting..."
  exit 1;
fi
 
nodeip=$1
nodeusername=$2
nodepassword=$3
nodename=$4

knife bootstrap $nodeip --ssh-user $nodeusername --ssh-password "$nodepassword" --sudo --use-sudo-password --node-name $nodename

if [ $? != 0 ]; then
  echo "Failed to Bootstrap node : $nodeip"
  exit 1;
fi

echo "Node Bootstraped successfully : $nodeip"

