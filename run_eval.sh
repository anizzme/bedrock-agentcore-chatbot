#!/bin/bash

# 1. Dynamically grab the S3 Bucket name and IAM Role ARN from CloudFormation
BUCKET_NAME=$(aws cloudformation describe-stacks --stack-name bug-report-testing-stack --query 'Stacks[0].Outputs[?OutputKey==`EvalDatasetBucketName`].OutputValue' --output text --region us-east-1)
ROLE_ARN=$(aws cloudformation describe-stacks --stack-name bug-report-testing-stack --query 'Stacks[0].Outputs[?OutputKey==`BedrockEvalRoleArn`].OutputValue' --output text --region us-east-1)

echo "Found Bucket: $BUCKET_NAME"
echo "Found Role: $ROLE_ARN"
echo "----------------------------------------"

# 2. Upload the JSONL dataset to the S3 bucket
echo "Uploading dataset to S3..."
aws s3 cp output_eval_dataset.jsonl s3://$BUCKET_NAME/output_eval_dataset.jsonl --region us-east-1
echo "----------------------------------------"

# 3. Trigger the Bedrock Evaluation Job
echo "Starting Bedrock Evaluation Job..."
aws bedrock create-evaluation-job \
  --job-name support-chatbot-eval-run-2 \
  --role-arn $ROLE_ARN \
  --evaluation-config '{
    "automated": {
      "datasetMetricConfigs": [{
        "taskType": "General",
        "dataset": {
          "name": "support-chatbot-eval-dataset",
          "datasetLocation": {
            "s3Uri": "s3://'"$BUCKET_NAME"'/output_eval_dataset.jsonl"
          }
        },
        "metricNames": ["Builtin.Correctness"]
      }],
      "evaluatorModelConfig": {
        "bedrockEvaluatorModels": [{
          "modelIdentifier": "amazon.nova-pro-v1:0"
        }]
      }
    }
  }' \
  --inference-config '{
    "models": [{
      "precomputedInferenceSource": {
        "inferenceSourceIdentifier": "my-support-chatbot"
      }
    }]
  }' \
  --output-data-config '{"s3Uri": "s3://'"$BUCKET_NAME"'/results/"}' \
  --region us-east-1

echo "----------------------------------------"
echo "Success! The evaluation job has been submitted."