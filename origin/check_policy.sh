#!/bin/bash

echo "Checking policy..."

command='../bin/cybr conjur get-secret -i originApplication/connectionstring'
echo ${command}
eval ${command}

command='../bin/cybr conjur get-secret -i originApplication/username'
echo ${command}
eval ${command}

command='../bin/cybr conjur get-secret -i originApplication/password'
echo ${command}
eval ${command}
