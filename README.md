# Terraform Proxmox

This workflow sets up a terraform state with secrets available to downstream workflows 

## Vault Structure

path of secrets in the vault will follow the pattern below

/{host|application}/{secret-name}
eaxmple 
/proxmox/bytevault/root-password
/k8cluster/rancher/postgres/admin-account
/k8cluster/rancher/postgres/admin-password

## Usage
to deploy this workflow link the environment tfvars folder to the root directory. 
```bash
  ln -s env/main.tf
  ln -s env/terraform.tfvars

  tofu init .
  tofu plan
  tofu apply
```

### Initializing the vault
```bash
# Generate the Sealing keys
vault operator init -key-shares=6 -key-threshold=3
```

```bash
# Unlocking the exisiting vault
vault operator unseal $UNSEAL_KEY_1
vault operator unseal $UNSEAL_KEY_2
vault operator unseal $UNSEAL_KEY_3
vault login $VAULT_DEV_ROOT_TOKEN_ID
vault status -format=json
```