# arca
A chest or strong box used in ancient times as a receptacle for money or valuables.

# Initialize a Project
```bash
arca init <appName>
```

# Add Conjur Policy
```bash
cd <appName>
add_policy.sh
```

# Copy files

# Grep and sed to replace values
Add `-i` after `sed` to make changes in place.
```bash
cd <appName>/src/<appName>
grep -rl "originApplication" . | xargs sed '' 's/originApplication/<appName>/g'
grep -rl "origin" . | xargs sed '' 's/origin/<appName>/g'
grep -rl "conjur/authn-iam/dev" . | xargs sed '' 's/conjur\/authn-iam\/dev/<conjurAccount>/g'
grep -rl "conjur/authn-iam" . | xargs sed '' 's/conjur\/authn-iam/<conjurAccount>/g'
grep -rl "conjur" . | xargs sed '' 's/conjur/<conjurAccount>/g'
grep -rl "prima" . | xargs sed '' 's/prima/<conjurAccount>/g'
grep -rl "560732129735" . | xargs sed '' 's/560732129735/<conjurAccount>/g'
grep -rl "secretApp" . | xargs sed '' 's/secretApp/<conjurAccount>/g'
grep -rl "TrustedWithSecret" . | xargs sed '' 's/TrustedWithSecret/<conjurAccount>/g'
grep -rl "pgUser" . | xargs sed '' 's/pgUser/<pgUser>/g'
grep -rl "pgPassword" . | xargs sed '' 's/pgPassword/<pgPassword>/g'
grep -rl "connectionString" . | xargs sed '' 's/connectionString/<connectionString>/g'
cd ../..
```

# Initialize Go Module
```bash
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

