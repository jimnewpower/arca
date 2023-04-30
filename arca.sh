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

    # Create project directory
    cp -R origin "$1"

    # Search and replace "origin" with project name
    find "$1" -type f -name 'add_policy.sh' -exec sed -i '' -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'build.sh' -exec sed -i '' -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'aws.tf' -exec sed -i '' -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'providers.tf' -exec sed -i '' -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'application.yml' -exec sed -i '' -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'root-policy.yml' -exec sed -i '' -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'secrets.yml' -exec sed -i '' -e "s/origin/$1/g" {} \;
    find "$1" -type f -name 'origin.go' -exec sed -i '' -e "s/origin/$1/g" {} \;

    mv "$1/src/origin" "$1/src/$1"
    mv "$1/src/$1/origin.go" "$1/src/$1/$1.go"
    
    # rename origin.go to projectname.go
#    filename="$1.go"
#    find "$1" -type f -name 'origin.go' -exec mv {} '${filename}' \;

    # Run go mod init


    # Print success message
    echo "Project $1 has been initialized."
    return 0
}

# Check if command argument is provided
if [[ $# -lt 2 ]]; then
    echo "Please provide a command and a project name."
    exit 1
fi

# Call the appropriate function based on the command provided
case $1 in
    "init")
        arca_init "$2"
        ;;
    *)
        echo "Invalid command: $1"
        echo "Usage: arca.sh init <name>"
        exit 1
        ;;
esac
