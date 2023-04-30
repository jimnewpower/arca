#!/bin/bash
rm -rf bin/
mkdir bin/

cd src
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ../bin/main main.go

cd ../

echo "Contents of bin/"
ls -l bin/
