💡 Module: lightsail (Simple Virtual Server Deployment)

This module provisions an AWS Lightsail instance — a simplified, low-cost virtual private server (VPS) designed for lightweight workloads such as test environments, microservices, or small web applications.
It includes automated key-pair creation, instance setup, and static IP attachment, ensuring the instance is immediately accessible via SSH and has a fixed public IP address.


🔹 Key Components

SSH Key Pair
    . Automatically creates an AWS Lightsail key pair (aws_lightsail_key_pair) using a public key stored in the module directory (id_rsa.pub).
    . This allows secure SSH access to the Lightsail instance.
    . Keeps your credentials consistent across environments.

Lightsail Instance
    . Provisions a Lightsail instance (aws_lightsail_instance) in the specified availability zone (default: ap-south-1a).
    . Uses customizable parameters:
       . blueprint_id → defines the OS image (e.g., amazon_linux_2, ubuntu_22_04)
       . bundle_id → defines compute size (CPU, RAM, disk)
    . Automatically applies common project tags for organization and cost tracking.

Static Public IP
    . Allocates a dedicated public IP (aws_lightsail_static_ip) for the instance.
    . Attaches it automatically via aws_lightsail_static_ip_attachment, ensuring a persistent and reliable public endpoint — even if the instance is restarted or replaced.


🔹 Outputs
| Output                    | Description                                  |
| ------------------------- | -------------------------------------------- |
| `lightsail_instance_name` | The name of the Lightsail instance           |
| `lightsail_public_ip`     | The fixed public IP assigned to the instance |


🔹 Module Inputs
| Variable            | Description                                           | Default          |
| ------------------- | ----------------------------------------------------- | ---------------- |
| `project_name`      | Prefix for naming Lightsail resources                 | —                |
| `availability_zone` | AWS AZ for Lightsail instance                         | `ap-south-1a`    |
| `blueprint_id`      | OS blueprint (e.g., `amazon_linux_2`, `ubuntu_22_04`) | `amazon_linux_2` |
| `bundle_id`         | Instance size (e.g., `nano_2_0`, `micro_2_0`)         | `nano_2_0`       |
| `common_tags`       | Map of tags applied to all resources                  | `{}`             |


🔹 Architecture Overview
    1. This module deploys:
        . A Lightweight VM (Lightsail) inside a specific AWS region
        . A Static Public IP to access it globally
        . An SSH key pair for secure authentication

    2. It’s ideal for:
        . Quick web or API hosting
        . Development or staging environments
        . Small-scale applications that don’t require full EC2/VPC complexity


🔹 Summary
✅ Creates secure SSH access via managed key pair
✅ Deploys a cost-effective Lightsail VM
✅ Assigns a permanent public IP
✅ Fully tagged and environment-ready


