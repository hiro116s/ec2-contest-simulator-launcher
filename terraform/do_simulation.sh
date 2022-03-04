terraform apply -auto-approve
ssh -oStrictHostKeyChecking=no ubuntu@$(terraform output -raw public_ip) -i $KEY_PATH ./run.sh
terraform destroy -auto-approve
