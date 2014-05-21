#!/bin/bash


service sshd start
start_dmxd

while true; do
	sleep 1000
done
	
