# Demo

#### Show database in pgAdmin.

#### Show go code.

```bash
./arca.sh create demo
```

#### Show directory layout.

```bash
make help
```

#### Talk about the make rules.

```bash
make clean build
```

#### Talk about policy. Show policy files.

```bash
make policy
```

#### Note the output from adding policy. Show the api_key.

```bash
make check
```

#### Set secrets.

```bash
conjur set-secret -i originApplication/connectionstring -v connectionstring
```

#### Run check to view the secrets.

```bash
make check
```

#### Run the terraform plan.

```bash
make lambda
```

#### Run the terraform apply.

```bash
make apply
```

#### Show the lambda in AWS. Show configuration. Add Function URL.

#### Make a modification in the go code, and rebuild/deploy.

#### Make a modification in the database, and run the lambda again.
