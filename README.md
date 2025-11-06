# terraform-origional

✅ Create a bucket
    aws s3 mb s3://tanvora-terraform-state-ajay --region ap-south-1

Create the DynamoDB table yet:
    aws dynamodb create-table \
    --table-name tanvora-terraform-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region ap-south-1


