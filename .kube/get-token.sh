#!/bin/bash

K8S_CLUSTER_NAME="cluster-$K8S_CLUSTER_ENV"
K8S_AWS_PROFILE="eks-$K8S_CLUSTER_ENV"
K8S_AWS_ACCOUNT_ID=$(aws configure get sso_account_id --profile $K8S_AWS_PROFILE)

result=$(aws --region us-east-1 eks get-token --cluster-name $K8S_CLUSTER_NAME --output json --role-arn arn:aws:iam::$K8S_AWS_ACCOUNT_ID:role/eks-cluster-admin-$K8S_CLUSTER_ENV 2>&1)
if [ $? -ne 0 ]; then
  # "Failed to get token, retrieving AWS credentials..."

  creds=$(aws configure export-credentials --profile $K8S_AWS_PROFILE --format env 2>/dev/null)
  if [ $? -ne 0 ]; then
    # "AWS credentials not found, logging in with SSO..."
    aws sso login --profile $K8S_AWS_PROFILE
    # "SSO login successful, exporting AWS credentials..."

    creds=$(aws configure export-credentials --profile $K8S_AWS_PROFILE --format env)
    # "AWS credentials set, retrying to get token..."
  fi
  eval "$creds"

  result=$(aws --region us-east-1 eks get-token --cluster-name $K8S_CLUSTER_NAME --output json --role-arn arn:aws:iam::$K8S_AWS_ACCOUNT_ID:role/eks-cluster-admin-$K8S_CLUSTER_ENV)
fi
echo "$result"
