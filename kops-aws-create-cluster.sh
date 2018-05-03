#  # Create a cluster in AWS
#  kops create cluster --name=kubernetes-cluster.example.com \
#  --state=s3://kops-state-1234 --zones=eu-west-1a \
#  --node-count=2
#
#  # Create a cluster in AWS that has HA masters.  This cluster
#  # will be setup with an internal networking in a private VPC.
#  # A bastion instance will be setup to provide instance access.
#
#  export NODE_SIZE=${NODE_SIZE:-m4.large}
#  export MASTER_SIZE=${MASTER_SIZE:-m4.large}
#  export ZONES=${ZONES:-"us-east-1d,us-east-1b,us-east-1c"}
#  export KOPS_STATE_STORE="s3://my-state-store"

#### You can create the kops IAM user
#
#aws iam create-group --group-name kops
#aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
#aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
#aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
#aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
#aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops
#aws iam create-user --user-name kops
#aws iam add-user-to-group --user-name kops --group-name kops
#aws iam create-access-key --user-name kops
#
#### configure the aws client to use your new IAM user
#
#aws configure           # Use your new access and secret key here
#aws iam list-users      # you should see a list of all your IAM users here
#
#### Because "aws configure" doesn't export these vars for kops to use, we export them now
#
#export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
#export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
#
####
# Currently only '--networking kopeio-vxlan (or kopeio)', '--networking weave', '--networking flannel', '--networking calico', '--networking canal', '--networking kube-router', '--networking romana', '--networking amazon-vpc-routed-eni' are supported for private topologies
###### need to create from templets
# Create a cluster from the configuration specification in a YAML file
#  kops create -f my-cluster.yaml
# Create secret from secret spec file
#  kops create -f secret.yaml


# Create a VPC
# Create a Subnet
# Create a DNS private Zone/use exiting
# Create an new ssh public key called admin.
#  kops create secret sshpublickey admin -i ~/.ssh/id_rsa.pub \
# Create a S3 store 
#  aws s3api create-bucket --bucket prefix-kube-velox-state-store --region us-west-1 --create-bucket-configuration LocationConstraint=us-west-1


CLOUD=${CLOUD:-"aws"}
NAME="k8s.example.com" # DNS ZONE NAME
DNS_ZONE_ID=${DNS_ZONE_ID:-""} # DNS hosted zone ID
VPC_ID="vpc-03bd31ce4ee401a6d"
IMAGE_NAME="RHEL-7.5_HVM_GA-20180322-x86_64-1-Hourly2-GP2"
IMAGE_ID="ami-18726478"
NODE_SIZE=${NODE_SIZE:-"t2.micro"}
MASTER_SIZE=${MASTER_SIZE:-"t2.micro"}
ZONES=${ZONES:-"us-west-1b,us-west-1c"}
NET_TOPO=${NET_TOPO:-"private"}
CNN=${CNN-"calico"}  # calico
LB_TYPE=${LB_TYPE:-"internal"}
KOPS_STATE_STORE="s3://prefix-kube-velox-state-store"

#kops update cluster $NAME --yes
# kops validate cluster
#  --bastion="true" \
#  --node-count 3 \

#--api-loadbalancer-type $LB_TYPE \
#--master-zones $ZONES \

kops create cluster $NAME \
  --cloud=$CLOUD \
  --image $IMAGE_ID \
  --vpc $VPC_ID \
  --node-size $NODE_SIZE \
  --master-size $MASTER_SIZE \
  --zones $ZONES \
  --networking $CNN \
  --topology $NET_TOPO \
  --dns $NET_TOPO \
  --dns-zone $DNS_ZONE_ID \
  --associate-public-ip="false" \
  --api-loadbalancer-type="internal"
  #--bastion=true
kops create secret --name $NAME sshpublickey admin -i ~/.ssh/id_rsa_admin.pub
