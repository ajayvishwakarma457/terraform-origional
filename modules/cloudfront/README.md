🌩️ CloudFront Module
📘 Overview

This module provisions a secure, production-ready CloudFront CDN integrated with an S3 origin, optional ACM certificate, and Origin Access Control (OAC) for private content delivery.

It automates every step needed to serve static assets or web content globally with low latency and high security — fully aligned with AWS best practices.


⚙️ What This Module Does

| Component                              | Purpose                                                                                                   |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| **S3 Bucket**                          | Stores static assets (e.g., web files, images). Versioning and AES-256 encryption are enabled by default. |
| **Public Access Block**                | Ensures the bucket is fully private and accessible only through CloudFront.                               |
| **Origin Access Control (OAC)**        | Replaces legacy OAI; securely grants CloudFront read access to S3.                                        |
| **CloudFront Distribution**            | Delivers content globally with caching, HTTPS enforcement, compression, and managed policies.             |
| **ACM Certificate (us-east-1)**        | Optional. Automatically creates and validates an SSL certificate for custom domains.                      |
| **Route 53 DNS Validation (optional)** | Creates DNS records for ACM certificate validation if a hosted zone ID is provided.                       |
| **S3 Bucket Policy**                   | Restricts bucket access so only the CloudFront distribution can read objects.                             |
| **Optional test index.html**           | Simple placeholder object to verify the setup.                                                            |



🧩 Inputs
| Variable                     | Description                                           | Default             |
| ---------------------------- | ----------------------------------------------------- | ------------------- |
| `project_name`               | Project prefix for naming resources                   | —                   |
| `aws_region`                 | Deployment region for S3 and related resources        | —                   |
| `common_tags`                | Common tags to apply to all resources                 | `{}`                |
| `bucket_name`                | (Optional) Custom S3 bucket name                      | Auto-generated      |
| `domain_name`                | (Optional) Custom domain for CDN                      | `""`                |
| `alternate_names`            | (Optional) Additional domain aliases                  | `[]`                |
| `route53_zone_id`            | (Optional) Route 53 hosted zone ID for DNS validation | `""`                |
| `price_class`                | CloudFront price class (`PriceClass_All`, etc.)       | `"PriceClass_100"`  |
| `create_test_index`          | Create simple index.html file for testing             | `false`             |
| `cache_policy_id`            | Custom or managed cache policy ID                     | AWS managed default |
| `origin_request_policy_id`   | Custom or managed origin request policy ID            | AWS managed default |
| `response_headers_policy_id` | (Optional) Response header policy ID                  | `null`              |


📤 Outputs
| Output                | Description                                  |
| --------------------- | -------------------------------------------- |
| `cdn_domain_name`     | CloudFront distribution domain name          |
| `cdn_id`              | CloudFront distribution ID                   |
| `s3_bucket_name`      | Name of the S3 bucket used as the CDN origin |
| `oac_id`              | Origin Access Control ID                     |
| `acm_certificate_arn` | ARN of the ACM certificate (if created)      |



🪄 Example Usage (root module)

module "cloudfront" {
  source       = "./modules/cloudfront"
  project_name = var.project_name
  aws_region   = var.aws_region
  common_tags  = var.common_tags

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  # Optional custom setup
  # bucket_name     = "tanvora-cdn"
  # domain_name     = "cdn.tanvora.com"
  # alternate_names = ["static.tanvora.com"]
  # route53_zone_id = module.route53.zone_id
}


🛡️ Security Features
. Private S3 bucket access (no public ACLs or policies)
. Enforced HTTPS via CloudFront
. Automatic SSL certificate validation
. Encrypted data at rest (AES-256)
. Signed CloudFront → S3 communication through OAC


🚀 Typical Use-Case
. Front-end asset CDN for web apps
. Global content delivery for static websites
. Secure, low-latency delivery for APIs or media assets


🏗️ Dependencies
. Optional route53 module (if ACM DNS validation via Route 53 is desired)
. Optional acm integration (if using a shared certificate instead of this module’s)