terraform apply -auto-approve
ssh -oStrictHostKeyChecking=no ubuntu@$(terraform output -raw public_ip) -i ~/.ssh/h-sag-tokyo.pem ./run.sh
terraform destroy -auto-approve
