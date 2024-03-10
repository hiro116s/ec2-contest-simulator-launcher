echo "# 1. start new instance"
terraform apply -auto-approve

echo "# 2. manually update ec2 image"
ssh -A -i $KEY_PATH -oStrictHostKeyChecking=no ubuntu@$(terraform output -raw public_ip)

echo "# 3. confirm"
read -p "Are you okay to proceed to take the snapshot? (\"Yes\" to proceed): " if_proceed
if [ "$if_proceed" != "Yes" ]; then
  echo "Aborted."
  exit 1
fi

instance_id=$(terraform output -raw instance_id)
launch_template_name=$(terraform output -raw launch_template_name)

echo "# 4. take an ami based on the modification above"
ami_id=$(aws ec2 create-image --instance-id $instance_id --name "AMI-$(date +%Y%m%d-%H%M%S)" --no-reboot --query 'ImageId' --output text)
# Wait for the AMI to be available
aws ec2 wait image-available --image-ids $ami_id

echo "# 5. Stop instance"
terraform destroy -auto-approve

echo "# 6. Update contest-simulator-template"
new_version=$(aws ec2 create-launch-template-version --launch-template-name $launch_template_name --source-version '$Latest' --launch-template-data "{\"ImageId\":\"$ami_id\"}" --query 'LaunchTemplateVersion.VersionNumber' --output text)

echo "# 7. Remove the old ami"
old_image_id=$(aws ec2 describe-launch-template-versions --launch-template-name $launch_template_name --versions '$Default' --query 'LaunchTemplateVersions[0].LaunchTemplateData.ImageId' --output text)
old_snapshot_id=$(aws ec2 describe-images --image-ids $old_image_id --query 'Images[0].BlockDeviceMappings[*].Ebs.SnapshotId' --output text)
aws ec2 deregister-image --image-id $old_image_id
aws ec2 delete-snapshot --snapshot-id $old_snapshot_id

echo "# 8. Update default version"
aws ec2 modify-launch-template --launch-template-name $launch_template_name --default-version $new_version
