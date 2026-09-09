#!/bin/bash

echo "1. Cleaning up AgentCore resources..."
python cleanup_agentcore.py

echo "2. Finding and emptying S3 bucket..."
# Dynamically grab the bucket name so we don't have to copy-paste IDs
BUCKET_NAME=$(aws cloudformation describe-stacks --stack-name bug-report-testing-stack --query 'Stacks[0].Outputs[?OutputKey==`EvalDatasetBucketName`].OutputValue' --output text --region us-east-1)

if [ -n "$BUCKET_NAME" ]; then
    echo "Emptying bucket: $BUCKET_NAME"
    aws s3 rm s3://$BUCKET_NAME --recursive --region us-east-1
else
    echo "Bucket not found, skipping empty step."
fi

echo "3. Deleting CloudFormation stacks..."
aws cloudformation delete-stack --stack-name bug-report-testing-stack --region us-east-1
aws cloudformation delete-stack --stack-name bug-report-tool-stack --region us-east-1

echo "4. Removing local virtual environment..."
rm -rf venv

echo "----------------------------------------"
echo "Cleanup complete! The teardown process has been initiated."