#!/bin/bash
echo "Enter your username:"
read username
if [[ ! "$username" =~ ^[a-zA-Z0-9]{1,22}$ ]]; 
then
	echo "Not good username"
	exit;
fi
