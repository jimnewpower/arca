Create AWS IAM Role: `LambdaRDSPostgresReadAccess`
Conjur Application (host): `originApplication`

Add Conjur policy. Make note of api_keys that are returned:
```bash
conjur append-policy -b root -f root-policy.yml
conjur append-policy -b conjur/authn-iam/dev -f secrets.yml 
conjur append-policy -b originApplication -f application.yml 
```

```bash
conjur list | rg originApplication
conjur set-secret -i originApplication/username -v pgUser
conjur set-secret -i originApplication/password -v pgPassword
conjur set-secret -i originApplication/connectionstring -v connectionString

conjur get-secret -i originApplication/username
conjur get-secret -i originApplication/password
conjur get-secret -i originApplication/connectionstring
```


# Note the api_key that is returned, e.g.
```json
    "created_roles": {
        "prima:host:conjur/authn-iam/dev/secretApp/560732129735/TrustedWithSecret": {
            "id": "prima:host:conjur/authn-iam/dev/secretApp/560732129735/TrustedWithSecret",
            "api_key": "cq7mpq172w7zr1gt7m2syj7fh27drrbs1hjjdqh17bn5rt2cz5emf"
        }
    }
```

# Note the api_key that is returned, e.g.
```json
    "created_roles": {
        "prima:host:originApplication/560732129735/originApplication": {
            "id": "prima:host:originApplication/560732129735/originApplication",
            "api_key": "25n6sewv7mtwq1w7pfwhqv0paf3pjhj7rcca56z3z0t2c83g2v05q"
        }
    }
```    
