# arca
A chest or strong box used in ancient times as a receptacle for money or valuables.

# Get certificate from Conjur server
```bash
openssl s_client -showcerts -connect localhost:443 < /dev/null 2> /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > conjur_cert.pem
```

# Initialize the environment
```bash
arca init
```

# Clone the origin project
```bash
arca create <projectname>
```

# Add Conjur Policy
```bash
cd <appName>
make policy
```

Set secrets:
```bash
conjur set-secret -i originApplication/connectionstring -v connectionstring
conjur set-secret -i originApplication/username -v username
conjur set-secret -i originApplication/password -v password
```

# Build the source
```bash
cd <appName>
make clean build
```

# Deploy the lambda
```bash
cd <appName>
make lambda apply
```

# Add Function URL
In `AWS -> Lambda`, go to `Configuration -> Function URL` and `Create function URL`.

# Links
- [Conjur Admin](https://ec2-34-204-42-151.compute-1.amazonaws.com)
- [Jenkins](ec2-18-237-228-26.us-west-2.compute.amazonaws.com:8080)

# Initialize Go Module
```bash
cd <appName>/src/main
go mod init github.com/jimnewpower/arca
go mod tidy

cd <appName>/src/<appName>
go mod init primalimited.com/origin

go get github.com/aws/aws-lambda-go/lambda
go get github.com/cyberark/conjur-api-go/conjurapi
go get github.com/cyberark/conjur-api-go/conjurapi/authn
go get github.com/lib/pq
```

# Build
```bash
cd <appName>/src/<appName>
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
```

