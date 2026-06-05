# Infrastructure Resources — Project 01 Streaming

## Account Info
- Account ID: 721534619742
- Region: us-east-1
- User: SaudAdmin

## Day 1 — S3 + CloudFront
| Resource | ID / Value |
|----------|-----------|
| S3 Bucket | streaming-platform-videos-721534619742 |
| CloudFront Distribution | E3N95KV4SNBXNR |
| CloudFront Domain | d2v4ycppasw3vu.cloudfront.net |
| OAC | E10SP59VTRS38S |

## Day 2 — VPC + Networking
| Resource | ID | CIDR |
|----------|----|------|
| VPC | vpc-0fb6e4e083a303c1a | 10.0.0.0/16 |
| NAT Gateway | nat-07c23b35389146719 | - |
| Elastic IP | eipalloc-096a4940060517080 | - |

## Subnets
| Name | ID | AZ | CIDR |
|------|----|----|------|
| public-subnet-1a | subnet-0413e375ba305cb77 | us-east-1a | 10.0.1.0/24 |
| public-subnet-1b | subnet-0dd5eb6e468abe254 | us-east-1b | 10.0.2.0/24 |
| private-subnet-1a | subnet-01c297d2cf90207c2 | us-east-1a | 10.0.11.0/24 |
| private-subnet-1b | subnet-09f2b7ca07ea3d4c3 | us-east-1b | 10.0.12.0/24 |

## Security Groups
| Name | ID |
|------|----|
| ec2-sg | sg-0f6c89549c4ed7f37 |
| alb-sg | sg-0fff1952de998394e |
| default | sg-0b2f8307bf0b77963 |

## Day 3 — Compute
| Resource | ID / Value |
|----------|-----------|
| ALB DNS | streaming-platform-alb-2097032124.us-east-1.elb.amazonaws.com |
| ASG Name | streaming-platform-asg |
| ASG Config | Min:2, Max:10, Desired:2 |
