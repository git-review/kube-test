#!/bin/bash

NAME=$1
aws s3api create-bucket --bucket ${NAME} --region us-west-1 --create-bucket-configuration LocationConstraint=us-west-1
aws s3api put-bucket-versioning --bucket ${NAME} --versioning-configuration Status=Enabled
