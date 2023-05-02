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

# Show make rules
```bash
make help
```

# Build the go source
```bash
make clean build
```

# Add Conjur Policy
Login as admin:
```bash
conjur logon --self-signed -a prima -p CyberArk_2023! -b https://ec2-34-204-42-151.compute-1.amazonaws.com -l admin
```

```bash
make policy
```

Login as new host:
```bash
conjur logon --self-signed -a prima -b https://ec2-34-204-42-151.compute-1.amazonaws.com -l host/originApplication/560732129735/originApplication
# Accept certificate, replace rc files. Then, copy the cert to the cert directory.
cp ~/conjur-prima.pem ./cert/conjur-dev.pem
```

Set secrets:
```bash
conjur set-secret -i originApplication/connectionstring -v connectionstring
conjur set-secret -i originApplication/username -v username
conjur set-secret -i originApplication/password -v password
```

Connection string:
```bash
prima.cvrj95nytzmd.us-west-2.rds.amazonaws.com
```

Username:
```bash
postgres
```

Password:
```bash
TrHa0C0a3PoQSXAd0OPS
```

Check policy:
```bash
make check
```

# Build and deploy the lambda
```bash
make lambda
make apply
```

# View Conjur user info
```bash
conjur whoami && conjur list > list.txt && ../bin/tree
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

