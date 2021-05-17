#!/bin/sh -l

TERRAFORM_DIRECTORY=$1
VALUES=$2

cd $TERRAFORM_DIRECTORY

echo 'Initializing Terraform'
terraform init

echo 'Creating TFVars file'
echo "$VALUES" >> terraform.tfvars.json

echo 'Switching to workspace'
VERSION=$(echo "$GITHUB_REF" | sed -e 's,.*/\(.*\),\1,')
terraform workspace new $VERSION || true
terraform workspace select $VERSION

echo 'Testing format'
terraform fmt -check

echo 'Generating plan'
terraform plan

echo 'Applying plan'
terraform apply -auto-approve