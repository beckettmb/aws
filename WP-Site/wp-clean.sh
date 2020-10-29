#!/bin/bash


#delete cloudformation stack
echo "[!] Deleting Cloudformation stacks..."
aws cloudformation delete-stack --stack-name wp-stack-2
aws cloudformation wait stack-delete-complete --stack-name wp-stack-2
aws cloudformation delete-stack --stack-name wp-stack
aws cloudformation wait stack-delete-complete --stack-name wp-stack
echo "[+] Cloudformation stacks deleted."

#delete ami
echo "[!] Deleting Ami..."
imgid=$(aws ec2 describe-images \
	--filters "Name=name,Values=wsami" \
	--query "Images[*].ImageId" --output=text)
snapid=$(aws ec2 describe-snapshots \
	--filters "Name=description,Values=*$imgid*" \
	--query "Snapshots[*].SnapshotId" --output=text)
aws ec2 deregister-image --image-id $imgid
aws ec2 delete-snapshot --snapshot-id $snapid
echo "[+] Ami deleted."

#delete key pair
echo "[!] Deleting key pair..."
aws ec2 delete-key-pair --key-name wp-ec2-key
rm -f wp-ec2-key.pem
echo "[+] Key pair deleted."
echo "[+] Done."
