#!/bin/bash
vault status
vault operator unseal $UNSEAL_KEY_1
vault operator unseal $UNSEAL_KEY_2
vault operator unseal $UNSEAL_KEY_3
vault status
vault login $VAULT_DEV_ROOT_TOKEN_ID