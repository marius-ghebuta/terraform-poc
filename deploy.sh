#!/bin/bash

echo "USAGE: source deploy.sh AWS_ACCESS_KEY AWS_SECRET_KEY module_name terraform_command"
echo "Example: source deploy.sh AWS_ACCESS_KEY AWS_SECRET_KEY 02-network apply"

export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export AWS_REGION="us-east-1"

environment="dev"
component=$3
command=$4
root_dir="terraform/environment/${environment}/${component}"
name_prefix="noaptea-companiilor"

export TF_VAR_region=$AWS_REGION
export TF_VAR_remote_state_bucket=$(aws s3api list-buckets --region=$TF_VAR_region |\
                                                           jq ' .Buckets[].Name' |\
                                                           grep $name_prefix |\
                                                           tr -d '"') 

export TF_VAR_dynamodb_table=$(aws dynamodb list-tables --region=$TF_VAR_region \
                                                        --query "TableNames[]" \
                                                        --no-cli-pager |\
                                                        grep $name_prefix |\
                                                        tr -d '"' |\
                                                        tr -d " ")
#Output variables
echo -e "\n\nUsing the variables:"
echo "REGION: $TF_VAR_region"
echo "BUCKET: $TF_VAR_remote_state_bucket"
echo "Dynamo: $TF_VAR_dynamodb_table"

#Moving into the components directory
cd $root_dir
#Terraform init using backend variables.
terraform init      -backend-config "region=$TF_VAR_region"  \
                    -backend-config "bucket=$TF_VAR_remote_state_bucket" \
                    -backend-config "dynamodb_table=$TF_VAR_dynamodb_table" \
                    -lock=true \
                    -reconfigure 



terraform $command  -var remote_state_bucket=${TF_VAR_remote_state_bucket} \
                    
                    

#Going back to the initial directory
cd - 
