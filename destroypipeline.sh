#!/bin/bash

for node in $(knife node list); do
  echo "Deleting node $node"
  knife node environment set $ node "_default"
  knife node run_list set thinkpad ""
  knife node delete $node --yes
  knife client delete $node --yes
done

echo "Done!"
