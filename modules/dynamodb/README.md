🧩 Module: DynamoDB

This module provisions a fully managed AWS DynamoDB table to store structured application data in a highly available, scalable, and secure way.
It follows AWS and Terraform best practices — enabling automatic scaling, encryption, and recovery for production-grade reliability.


⚙️ What This Module Does

1 Creates a DynamoDB Table
    . Defines a table with a partition key (hash key) and optional sort key (range key).
    . Supports both simple (only hash key) and composite (hash + sort key) data models.
    . Uses the specified billing mode:
        PAY_PER_REQUEST for automatic scaling (default).
        PROVISIONED for manual throughput settings.

2. Enables Data Protection Features
    . Server-Side Encryption (SSE) is automatically enabled to encrypt all data at rest.
    . Point-in-Time Recovery (PITR) is enabled to allow restoring the table to any second within the last 35 days — protecting against accidental deletes or corruption.

3. Supports Flexible Schema Configuration
    . Accepts user-defined attributes for partition and sort keys.
    . Handles optional sort key logic dynamically — created only when a value is provided.

4. Adds Consistent Tagging
    . Applies standard project-wide tags from common_tags for cost tracking and resource organization.
    . Automatically names the table using the pattern:
        <project_name>-dynamodb-<table_name>

5. Outputs
    . table_name → the DynamoDB table name.
    . table_arn → the ARN (Amazon Resource Name) of the table for referencing in other AWS services.


🧠 In Summary
This module sets up a secure, scalable, and fault-tolerant DynamoDB table ready for production use.
It follows enterprise best practices with encryption, recovery, tagging, and modular configuration — ideal for storing user data, sessions, configurations, logs, or metadata in serverless or distributed systems.


✅ Exactly — you got it right.
This DynamoDB module creates a production-grade DynamoDB database, meaning it’s configured with all the key features and safeguards that real-world production environments use:

. Highly available (fully managed by AWS, no downtime or maintenance).
. Secure by default → with encryption (server_side_encryption) enabled.
. Recoverable → via point_in_time_recovery for data restore.
. Scalable → using PAY_PER_REQUEST mode to handle traffic automatically.
. Flexible schema → supports both simple and composite key structures.
. Tagged and versioned → for easy cost tracking and project organization.