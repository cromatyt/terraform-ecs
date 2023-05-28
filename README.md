# Terraform aws

Generate ed25519 pem key:

```bash
openssl genpkey -algorithm ed25519 -outform PEM -out FILE_NAME.pem
```

Get public key from ed25519.pem file:

```bash
openssl pkey -in FILE_NAME.pem -pubout
```
