#!/bin/bash

echo "You must be logged into Conjur as admin to add policy."
echo "Running whoami:"
../bin/cybr conjur whoami
echo ""

append_root='../bin/cybr conjur append-policy -b root -f ./config/policy/root-policy.yml'
echo ${append_root}
eval ${append_root}

#append_secrets='../bin/cybr conjur append-policy -b conjur/authn-iam/dev -f ./config/policy/secrets.yml'
#echo ${append_secrets}
#eval ${append_secrets}

append_application='../bin/cybr conjur append-policy -b originApplication -f ./config/policy/application.yml'
echo ${append_application}
eval ${append_application}

echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "TODO:"
echo "1. Copy the api_key above to use when running 'make lambda'"
echo "2. Set secret values in Conjur: connectionstring, username, password"
echo ""
echo "Example: conjur set-secret -i originApplication/connectionstring -v connectionstring"
echo ""