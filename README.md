# Terraform Application

This workflow sets up a terraform state with secrets available to downstream workflows 

This workflow will deploy a full vault using tls certs using a generated root CA as well as client certs. 

##### Dependancies
- 

### Conventions
---
#### 

## Deployment
to deploy this workflow link the environment tfvars folder to the root directory. 
```bash
  ln -s env/main.tf
  ln -s env/terraform.tfvars

  tofu init .
  tofu plan
  tofu apply
```
## Post Deployment

1. Initializing the vault
```bash
export VAULT_ADDR='https://localhost:8200'
export VAULT_CAPATH=/usr/local/share/ca-certificates/cert-intranet.pem.crt
# Generate the Sealing keys
vault operator init -key-shares=6 -key-threshold=3
```

2. unlock the vault either run the commands below or use the helper script in ./scrips/unseal.sh

```bash
# Unlocking the exisiting vault
vault operator unseal $UNSEAL_KEY_1
vault operator unseal $UNSEAL_KEY_2
vault operator unseal $UNSEAL_KEY_3
vault login $VAULT_DEV_ROOT_TOKEN_ID
vault status -format=json
```

## Notes 
- Add Root Cert as trusted on the local machine
```bash
sudo cp ./keys/**/*.pem.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates --fresh
```
- add the unlock tokens to the proxmox.env source the file using `source proxmox.env`
```bash
export VAULT_ADDR='https://localhost:8200'
export VAULT_CAPATH=/usr/local/share/ca-certificates/cert-intranet.pem.crt
export VAULT_DEV_ROOT_TOKEN_ID=hvs.XXXXXXXXXXXXXXXXXXXXXX
export UNSEAL_KEY_1=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export UNSEAL_KEY_2=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export UNSEAL_KEY_3=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```