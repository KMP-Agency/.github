#!/bin/sh -l

VALUES=$1
TERRAFORM_DIRECTORY=$2

cd $TERRAFORM_DIRECTORY

echo 'Creating TFVars file'
echo "$VALUES" >> terraform.tfvars.json

echo 'Testing format'
terraform fmt -check

echo 'Generating plan'
terraform plan

echo 'Applying plan'
terraform apply -auto-approve