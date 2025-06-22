#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="$1"
REGION="${2:-us-west-1}"

# 1. Create the bucket
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --create-bucket-configuration LocationConstraint="$REGION"

# 2. Enable versioning
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

# 3. Block all public access
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
  }'

# 4. Enforce server-side encryption (AES256)
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

# 5. Require HTTPS-only (deny any request without secure transport)
aws s3api put-bucket-policy \
  --bucket "$BUCKET_NAME" \
  --policy '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "DenyInsecureConnections",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": [
          "arn:aws:s3:::'"$BUCKET_NAME"'",
          "arn:aws:s3:::'"$BUCKET_NAME"'/*"
        ],
        "Condition": {
          "Bool": {
            "aws:SecureTransport": "false"
          }
        }
      }
    ]
  }'

echo "S3 bucket '$BUCKET_NAME' created with:"
echo "- Versioning enabled"
echo "- Public access fully blocked"
echo "- AES256 server-side encryption"
echo "- HTTPS-only enforcement"