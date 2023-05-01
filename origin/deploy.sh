#!/bin/bash
#export TF_VAR_CONJUR_ACCOUNT="prima"
#export TF_VAR_CONJUR_APPLIANCE_URL="https://ec2-34-204-42-151.compute-1.amazonaws.com"
#export TF_VAR_CONJUR_CERT_FILE="./conjur-dev.pem"
#export TF_VAR_CONJUR_AUTHN_LOGIN="admin"
#export TF_VAR_CONJUR_AUTHN_API_KEY="18wv7sck9a66015fzsv3252qfvp23anzs81qkn4f916fbs3t228p4nb"
#export TF_VAR_CONJUR_AUTHENTICATOR="authn-iam"

mkdir -p config/env
(cp ../env.sh config/env/env.sh)
(cp config/env/env.sh deploy/env.sh)
(cd deploy; mkdir -p archive)
(cd deploy; cp ../bin/main ./archive)
(cd deploy; cp ../cert/conjur-dev.pem ./archive)

(cd deploy; terraform init)
(cd deploy; terraform plan)

echo ""
echo ""
echo "Run 'terraform apply' to deploy the lambda function."