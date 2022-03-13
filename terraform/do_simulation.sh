terraform apply -auto-approve
scp -i $KEY_PATH -oStrictHostKeyChecking=no run.sh ubuntu@$(terraform output -raw public_ip):~
ssh -i $KEY_PATH -oStrictHostKeyChecking=no ubuntu@$(terraform output -raw public_ip) ./run.sh
terraform destroy -auto-approve
