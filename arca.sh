#!/bin/bash

function conjur_get_api_key() {
  curl -k -s -X GET -u admin:"CyberArk_2023!" ${CONJUR_URL}/authn/prima/login
}

# Define function to initialize the project
function arca_init() {
    # Initialize the environment
    echo "Initializing the environment..."

    # Check if env.json exists
    if [[ -f "env.json" ]]; then
        conjur_account=$(jq -r '.CONJUR_ACCOUNT' env.json)
        conjur_appliance_url=$(jq -r '.CONJUR_APPLIANCE_URL' env.json)
    fi

    read -r -p "Conjur account [$conjur_account]: " account
    # if account is not empty and is not equal to conjur_account, use account
    if [[ ! -z "$account" && "$account" != "$conjur_account" ]]; then
        conjur_account=$account
    fi

    read -r -p "Conjur appliance URL [$conjur_appliance_url]: " url
    # if url is not empty and is not equal to conjur_appliance_url, use url
    if [[ ! -z "$url" && "$url" != "$conjur_appliance_url" ]]; then
        conjur_appliance_url=$url
    fi

    # Check if the variables are empty
    if [[ -z "$conjur_account" ]]; then
        echo "ERROR: CONJUR_ACCOUNT is empty"
        return 1
    fi

    if [[ -z "$conjur_appliance_url" ]]; then
        echo "ERROR: CONJUR_APPLIANCE_URL is empty"
        return 1
    fi

    # Generate the script to set the environment variables in terraform.
    envscript="env.sh"
    echo "#!/bin/sh" > $envscript
    echo " env.sh" >> $envscript
    echo "" >> $envscript
    echo "# Change the contents of this output to get the environment variables" >> $envscript
    echo "# of interest. The output must be valid JSON, with strings for both" >> $envscript
    echo "# keys and values." >> $envscript
    echo "cat <<EOF" >> $envscript
    echo "{" >> $envscript
    echo "  \"LAMBDA_FUNCTION\" : \"originApplication\"," >> $envscript
    echo "  \"LAMBDA_FUNCTION_HANDLER\" : \"main\"," >> $envscript
    echo "  \"CONJUR_ACCOUNT\" : \"$conjur_account\"," >> $envscript
    echo "  \"CONJUR_APPLIANCE_URL\" : \"$conjur_appliance_url\"," >> $envscript
    echo "  \"CONJUR_CERT_FILE\" : \"./conjur-dev.pem\"," >> $envscript
    echo "  \"CONJUR_AUTHN_LOGIN\" : \"admin\"," >> $envscript
    echo "  \"CONJUR_AUTHN_API_KEY\" : \"$(conjur_get_api_key)\"," >> $envscript
    echo "  \"CONJUR_AUTHENTICATOR\" : \"authn-iam\"," >> $envscript
    echo "  \"DB_PORT\" : \"5432\"" >> $envscript
    echo "}" >> $envscript
    echo "EOF" >> $envscript

    chmod u+x $envscript

    aws configure
    
    tree

    echo ""
    echo "make commands in origin directory:"
    cd origin
    make help

    return 0
}

# Define function to initialize the project
function arca_create() {
    # Check if project name is provided
    if [[ $# -eq 0 ]]; then
        echo "Please provide a project name."
        return 1
    fi

    # Check if project directory already exists
    if [[ -d "$1" ]]; then
        echo "Project directory \"$1\" already exists. Exiting."
        return 1
    fi

    # Clean origin directory
    cd origin
    make clean
    cd ..

    # Create project directory
    cp -R origin "$1"

    rm -f "$1"/deploy/terraform.tfstate
    rm -f "$1"/deploy/terraform.tfstate.backup
    rm -rf "$1"/deploy/.terraform

    find "$1" -type f -name 'env.sh' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'add_policy.sh' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'build.sh' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'aws.tf' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'providers.tf' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'application.yml' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'root-policy.yml' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'secrets.yml' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'users.yml' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'go.mod' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'main.go' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'lambdaFunctionURLPolicy.json' -exec sed -i -e "s/origin/$1/g" {} \;

    # Search for origin in files
    if [[ $(grep -r "origin" "$1"/*) ]]; then
        echo "Error: origin found in files:"
        rg origin "$1"
        return 1
    fi

    # Print success message
    echo "Project $1 has been initialized. Lambda name is $1Application."
    tree $1

    echo ""
    echo "Next steps:"
    echo "1. cd $1"
    echo "2. make policy"
    echo "3. Set secrets in Conjur (conjur set-secret -i $1Application/connectionstring -v connectionstring)"
    echo "4. make clean build"
    echo "5. make lambda apply"
    echo "6. Add function URL (AWS -> Lambda -> Functions -> $1 -> Configuration -> Function URL -> Create function URL)."

    return 0
}

function arca_help() {
    echo "Usage: arca.sh <command> <project>"
    echo ""
    echo "Commands:"
    echo "    init              Initialize the environment."
    echo "    create <project>  Initialize a new project (clones origin project, and renames everything)."
    echo "    help              Print this help message."
    echo ""
    return 0
}

# Check if no arguments
if [[ $# -eq 0 ]]; then
    arca_help
    exit 0
fi

# Call the appropriate function based on the command provided
case $1 in
    "init")
        arca_init
        ;;
    "create")
        if [[ $# -eq 2 ]]; then
            arca_create "$2"
        else
            arca_help
        fi
        ;;
    "help")
        arca_help
        ;;
    *)
        arca_help
        ;;
esac
