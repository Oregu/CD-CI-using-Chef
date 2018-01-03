#!/bin/bash

# Assigns below environment, roles and cookbooks in csv format to build machine node.

if [ $# -lt 3 ]; then
  echo "Invalid arguments! Please provide input arguments(s) in format : ./$0 <nodename> <environment> <run_list>. Failed to assign runlist to node. Exiting..."
  exit 1
fi

nodename=$1
env=$2
runlist=$3 # includes roles and cookbooks

knife node environment set $nodename $env
if [ $? != 0 ]; then
  echo "Failed to assign Environment $env to node $nodename . Exiting..."
  exit 1;
else
  echo "Node $nodename assigned Environment $env successfully."
fi

knife node run_list add $nodename $runlist
if [ $? != 0 ]; then
  echo "Failed to assign Run List $env to node $nodename . Exiting..."
  exit 1;
else
  echo "Node $nodename assigned Run List $runlist successfully."
fi

echo "Environment and Run List assigned successfully to node $nodename ."
