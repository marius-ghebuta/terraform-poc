# Terraform DEMO


# Prepare AWS credentials
source prepare.sh <ACCESS_KEY_ID> <SECRET_ACCESS_KEY>

# Terrafor init with backend config

terraform_13 init   -backend-config "region=$TF_VAR_region"  \
                    -var remote_state_bucket=${remote_state_bucket} \
                    -var region=${TF_VAR_region} \
                    -lock=true