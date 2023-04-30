#!/bin/bash
append_root='conjur append-policy -b root -f root-policy.yml'
echo ${append_root}
eval ${append_root}

append_secrets='conjur append-policy -b conjur/authn-iam/dev -f secrets.yml'
echo ${append_secrets}
eval ${append_secrets}

append_application='conjur append-policy -b originApplication -f application.yml'
echo ${append_application}
eval ${append_application}


