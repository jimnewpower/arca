#!/bin/bash

# Define function to initialize the project
function arca_init() {
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

    find "$1" -type f -name 'add_policy.sh' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'build.sh' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'aws.tf' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'providers.tf' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'application.yml' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'root-policy.yml' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'secrets.yml' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'go.mod' -exec sed -i -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'main.go' -exec sed -i -e "s/origin/$1/g" {} \;

    # Search for origin in files
    if [[ $(rg origin "$1") ]]; then
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
    echo "  init <project>  Initialize a new project."
    echo "  help            Print this help message."
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
        arca_init "$2"
        ;;
    "help")
        arca_help
        ;;
    *)
        echo "Invalid command: $1"
        echo "Usage: arca.sh init <name>"
        exit 1
        ;;
esac
