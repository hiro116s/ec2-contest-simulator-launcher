# ec2-contest-simulator-launcher
## Preparation
1. Create `terraform.tfvars` file under `terraform` directory.
```
region   = "ap-northeast-1"
key_path = "/path/to/your/ssh/key"
```
2. Create `run.sh` file under `terraform` directly incluing the scripts you want to run in the ec2 instance.
## How to start simulation
```
cd terraform
terraform init
./do_simulation.sh
```
