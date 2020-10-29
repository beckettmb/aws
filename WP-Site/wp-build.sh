#!/bin/bash


#get username and password
echo "Please enter a username for the RDS instance"
read usn
echo "Please enter a password for the RDS instance"
read psw

#create key pair
echo "[!] Creating key pair..."
aws ec2 create-key-pair \
	--key-name wp-ec2-key \
	--query "KeyMaterial" --output=text > wp-ec2-key.pem
chmod 400 wp-ec2-key.pem
echo "[+] Key pair created."

#create cloudformation stack
echo "[!] Creating Cloudformation stack..."
aws cloudformation create-stack \
	--stack-name wp-stack \
	--parameters ParameterKey=Username,ParameterValue=$usn \
		ParameterKey=Password,ParameterValue=$psw \
	--template-body file://wp-template.yaml > /dev/null
aws cloudformation wait stack-create-complete --stack-name wp-stack
echo "[+] Cloudformation stack created."

#create ami
sleep 2m
echo "[!] Creating ami..."
ec2id=$(aws ec2 describe-instances \
	--filters "Name=tag:Name,Values=webserver" "Name=instance-state-name,Values=running" \
	--query "Reservations[*].Instances[*].InstanceId" --output=text)
imgid=$(aws ec2 create-image \
	--instance-id $ec2id \
	--name wsami \
	--output=text)
aws ec2 wait image-available --image-ids $imgid
echo "[+] Ami created."

#create cloudformation stack
echo "[!] Creating Cloudformation stack..."
aws cloudformation create-stack \
	--stack-name wp-stack-2 \
	--parameters ParameterKey=ImageId,ParameterValue=$imgid \
	--template-body file://wp-template-2.yaml > /dev/null
aws cloudformation wait stack-create-complete --stack-name wp-stack-2
echo "[+] Cloudformation stack created."

#print url
aws cloudformation describe-stacks \
	--stack-name wp-stack \
	--query "Stacks[*].Outputs[4].OutputValue" --output=text
echo "[+] Done."
