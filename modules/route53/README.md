🌐 Module: route53 (Domain & DNS Management)
This module automates the setup and management of Amazon Route 53 DNS records for a project’s custom domain.
It establishes the domain’s hosted zone, maps the root and subdomains to key AWS services (like ALB, CloudFront, or App Runner), and exposes the required name servers for domain registrar configuration (e.g., GoDaddy).


🔹 Key Components

1. Hosted Zone Creation
    . Creates a public hosted zone in Route 53 for the specified domain (var.domain_name).
    . This hosted zone becomes the authoritative DNS for the domain, managing all its records.
    . Outputs the name servers (NS records) which must be updated in your domain registrar (GoDaddy) to activate DNS routing.

2. Root Domain Alias → Application Load Balancer
    . Creates an A record (alias) that points the root domain (e.g., spakcommgroup.com) directly to your Application Load Balancer (ALB).
    . The alias uses the ALB’s DNS name and hosted zone ID, allowing Route 53 to automatically route web traffic to the ALB.

3. CDN Subdomain Alias → CloudFront (Optional)
    . Optionally creates a cdn.<domain> alias record that maps to your CloudFront distribution for static content delivery.
    . Controlled by the flag create_cdn_record (default: true).
    . Uses the global CloudFront hosted zone ID (Z2FDTNDATAQYW2) and distribution domain name.

4. API Subdomain Alias → ALB or App Runner (Optional)
    . Optionally creates an api.<domain> alias that routes API traffic to a backend load balancer or App Runner service.
    . Controlled by the flag create_api_record (default: false).
    . Supports both internal or external endpoints by accepting DNS and zone ID variables.


🔹 Outputs

| Output             | Description                                      |
| ------------------ | ------------------------------------------------ |
| `route53_zone_id`  | The hosted zone ID created in Route 53           |
| `name_servers`     | List of NS records to configure at GoDaddy       |
| `root_record_name` | The root A record that routes traffic to the ALB |
| `cdn_record_name`  | The CDN subdomain (if enabled)                   |
| `api_record_name`  | The API subdomain (if enabled)                   |
| `app_domain_name`  | Example domain mapping (app.spakcommgroup.com)   |


🔹 Integration in Root Module

    1. This module ties DNS and traffic routing into the rest of your AWS infrastructure:
        . ALB DNS name + zone ID → from the scaling module
        . CloudFront info → from the cloudfront module
        . API DNS (optional) → from apprunner or alb modules
    2. Together, they allow end-users to access your app securely through a custom domain (e.g., https://spakcommgroup.com).


🔹 Summary
    ✅ Creates and manages a public hosted zone
    ✅ Connects your domain to AWS resources (ALB, CloudFront, App Runner)
    ✅ Provides NS records for registrar configuration
    ✅ Enables optional subdomains (cdn, api) for modular architecture


In short:
    The route53 module establishes the domain’s DNS foundation — connecting your GoDaddy-registered domain to AWS services like ALB and CloudFront, enabling secure, production-grade traffic routing.