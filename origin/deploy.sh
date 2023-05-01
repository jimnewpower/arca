#!/bin/bash

# check if config/env/env.sh exists
if [ ! -e "config/env/env.sh" ]; then
    cp ../env.sh ./config/env/env.sh
fi

(cp config/env/env.sh deploy/env.sh)
(cd deploy; mkdir -p archive)
(cd deploy; cp ../bin/main ./archive)
(cd deploy; cp ../cert/conjur-dev.pem ./archive)

(cd deploy; terraform init)
(cd deploy; terraform plan)

echo ""
echo ""
echo "Run 'terraform apply' to deploy the lambda function."