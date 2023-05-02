#!/bin/bash

echo "Checking policy..."

echo ""
command='../bin/cybr conjur get-secret -i originApplication/connectionstring'
echo ${command}
eval ${command}

echo ""
command='../bin/cybr conjur get-secret -i originApplication/username'
echo ${command}
eval ${command}

echo ""
command='../bin/cybr conjur get-secret -i originApplication/password'
echo ${command}
eval ${command}

echo ""
echo "conjur set-secret -i originApplication/connectionstring -v str"
echo "conjur set-secret -i originApplication/username -v str"
echo "conjur set-secret -i originApplication/password -v str"
echo ""