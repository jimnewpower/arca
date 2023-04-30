#!/bin/bash
rm -rf bin/
mkdir bin/

cd src/origin
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ../../bin/origin origin.go
chmod u+x ../../bin/origin
cd ../..

rm -rf archive
mkdir archive
cd archive
cp ../bin/origin .
cp ../cert/conjur-dev.pem .
zip origin.zip origin conjur-dev.pem
rm origin conjur-dev.pem
less origin.zip
cd ..

echo "Contents of bin/"
ls -l bin/

echo "Contents of archive/"
ls -l archive/

echo "Contents of archive/origin.zip"
unzip -l archive/origin.zip
