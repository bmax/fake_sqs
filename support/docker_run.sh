#!/bin/bash

IP=$(ip addr show eth0 | grep 'inet ' | awk '{ print $2}' | cut -f1 -d'/')

echo "---- Starting fake sqs service on ip $IP ----"
echo ""

bin/fake_sqs --bind $IP
