#!/bin/bash

append_root='../bin/cybr conjur append-policy -b root -f ./config/policy/root-policy.yml'
echo ${append_root}
eval ${append_root}

#append_secrets='../bin/cybr conjur append-policy -b conjur/authn-iam/dev -f ./config/policy/secrets.yml'
#echo ${append_secrets}
#eval ${append_secrets}

append_application='../bin/cybr conjur append-policy -b originApplication -f ./config/policy/application.yml'
echo ${append_application}
eval ${append_application}


