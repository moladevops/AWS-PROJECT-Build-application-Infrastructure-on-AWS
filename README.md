# Scalable Multi-Tier Web Application on AWS

## Overview
Team project to design and deploy a scalable, secure and highly available
multi-tier web application on AWS, fully defined as Infrastructure as Code.

## Architecture
| Layer | AWS services | Purpose |
|---|---|---|
| Network | VPC, public and private subnets | Isolated network across multiple Availability Zones |
| Traffic | Elastic Load Balancer (ELB) | Distributes requests across web server instances |
| Compute | EC2, Auto Scaling Group | Scales horizontally based on CPU usage and instance health |
| Database | Amazon RDS | Managed relational databases |
| Storage | EBS, S3 | Instance storage, log storage and backups |
| Shared files | Amazon EFS | Shared file system so all instances serve the same content |
| DNS | Route 53 | Domain registration and DNS records |
| Monitoring | CloudWatch | Metrics, alarms and application monitoring |
| Notifications | SNS | Alerts when instances are launched or terminated |
| Security | IAM users, groups and roles | Console access control; EC2 roles to access S3 without stored credentials |
| Automation | Terraform / CloudFormation | Reproducible infrastructure with no manual setup |

## Key features
- **High availability**: load balancing across multiple Availability Zones
- **Auto scaling**: instances added or removed automatically based on CPU load
- **Security**: least-privilege IAM, private subnets for databases
- **Observability**: CloudWatch alarms with SNS email notifications
- **Infrastructure as Code**: the whole stack can be recreated with one command

## Skills demonstrated
AWS architecture · Networking (VPC, subnets) · Auto Scaling · Load balancing ·
IAM · Monitoring · Infrastructure as Code (Terraform)
