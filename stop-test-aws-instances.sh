
#!/bin/bash

VPCID="vpc-0446e93aad0f2ed3d"
echo "Stopping ec2 instanaces in VPC:${VPCID}"
for i in `aws ec2 describe-instances --no-paginate | jq -r '.Reservations[].Instances[] | select(.VpcId=='\"${VPCID}\"') | .InstanceId'` 
do 
aws ec2 stop-instances --instance-ids $i
done 
