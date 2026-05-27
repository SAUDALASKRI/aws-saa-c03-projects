<div align="center">

```
 █████╗ ██╗    ██╗███████╗    ███████╗ █████╗  █████╗      ██████╗ ██████╗ ██████╗
██╔══██╗██║    ██║██╔════╝    ██╔════╝██╔══██╗██╔══██╗    ██╔════╝██╔═══██╗╚════██╗
███████║██║ █╗ ██║███████╗    ███████╗███████║███████║    ██║     ██║   ██║ █████╔╝
██╔══██║██║███╗██║╚════██║    ╚════██║██╔══██║██╔══██║    ██║     ██║   ██║ ╚═══██╗
██║  ██║╚███╔███╔╝███████║    ███████║██║  ██║██║  ██║    ╚██████╗╚██████╔╝██████╔╝
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚═════╝
```

# 🏗️ Five Comprehensive Projects | AWS Solutions Architect Associate — SAA-C03

<img src="https://img.shields.io/badge/AWS-SAA--C03-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white"/>
<img src="https://img.shields.io/badge/Level-Beginner_to_Advanced-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/AWS_Services-30%2B-00B4D8?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/IaC-CloudFormation-FF4757?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/Exam_Coverage-~80%25-7C3AED?style=for-the-badge"/>

> **A hands-on, end-to-end guide** to building real AWS infrastructure from scratch to production.
> Every project is explained step by step with ready-to-deploy CloudFormation templates.

</div>

---

## 📋 Table of Contents

- [🎯 Exam Domain Overview](#-exam-domain-overview)
- [🗂️ The Five Projects](#️-the-five-projects)
- [🚀 Getting Started](#-getting-started)
- [📚 Prerequisites](#-prerequisites)
- [💰 Cost Estimates](#-cost-estimates)
- [🗺️ Recommended Learning Path](#️-recommended-learning-path)
- [🤝 Contributing](#-contributing)

---

## 🎯 Exam Domain Overview

The SAA-C03 exam covers **4 key domains**. Our projects map to all of them:

| Domain | Exam Weight | Projects Covered |
|--------|:-----------:|-----------------|
| 🔵 **Design Secure Architectures** | 30% | P02 ✦ P04 |
| 🟠 **Design Resilient Architectures** | 26% | P01 ✦ P04 |
| 🟢 **Design High-Performing Architectures** | 24% | P01 ✦ P03 ✦ P05 |
| 🟡 **Design Cost-Optimized Architectures** | 20% | P02 ✦ P03 ✦ P05 |

---

## 🗂️ The Five Projects

<table>
<tr>
<td width="60px" align="center"><b>P01</b></td>
<td>

### 🎬 [High-Availability Media Streaming Platform](./project-01-streaming/README.md)

Build a full CDN + Live Streaming platform that handles millions of concurrent users with 99.99% uptime.

**Core Services:**
`CloudFront` `S3` `MediaLive` `MediaConvert` `ALB` `Auto Scaling` `Route 53` `WAF` `ElastiCache`

**What you'll learn:** Multi-Region architecture, CDN caching strategies, DDoS protection, Auto Scaling policies

![Duration](https://img.shields.io/badge/Duration-3--4_Weeks-FF9900?style=flat-square)
![Difficulty](https://img.shields.io/badge/Difficulty-Advanced-orange?style=flat-square)
![Cost](https://img.shields.io/badge/Est._Cost-$150--300/mo-lightgrey?style=flat-square)

</td>
</tr>
<tr>
<td align="center"><b>P02</b></td>
<td>

### 🏦 [Secure Serverless Banking System](./project-02-serverless-banking/README.md)

Fully serverless financial transaction system with complete PCI-DSS and SOC2 compliance.

**Core Services:**
`Lambda` `API Gateway` `DynamoDB` `Cognito` `KMS` `SQS` `Step Functions` `GuardDuty` `CloudTrail`

**What you'll learn:** Serverless architecture, encryption at rest/transit, audit logging, event-driven design

![Duration](https://img.shields.io/badge/Duration-4--5_Weeks-00D084?style=flat-square)
![Difficulty](https://img.shields.io/badge/Difficulty-Expert-red?style=flat-square)
![Cost](https://img.shields.io/badge/Est._Cost-~$0_Free_Tier-lightgrey?style=flat-square)

</td>
</tr>
<tr>
<td align="center"><b>P03</b></td>
<td>

### 📊 [Big Data Analytics Platform — Enterprise Data Lake](./project-03-data-lake/README.md)

Analyze petabytes of data with a full ML pipeline and real-time business insights.

**Core Services:**
`S3` `Glue` `Athena` `Kinesis` `EMR` `Redshift` `SageMaker` `QuickSight` `Lake Formation`

**What you'll learn:** Medallion architecture, ETL pipelines, data cataloging, ML on AWS

![Duration](https://img.shields.io/badge/Duration-5--6_Weeks-00B4D8?style=flat-square)
![Difficulty](https://img.shields.io/badge/Difficulty-Expert-red?style=flat-square)
![Cost](https://img.shields.io/badge/Est._Cost-$200--400/mo-lightgrey?style=flat-square)

</td>
</tr>
<tr>
<td align="center"><b>P04</b></td>
<td>

### 🏢 [Multi-Tenant SaaS Platform + Disaster Recovery](./project-04-saas-multitenant/README.md)

Enterprise SaaS with full tenant isolation, RTO < 15 minutes, and RPO < 5 minutes.

**Core Services:**
`Organizations` `Control Tower` `EKS` `Aurora Global` `AWS Backup` `DRS` `Transit Gateway` `RAM`

**What you'll learn:** Multi-account strategy, Kubernetes on AWS, global databases, DR testing

![Duration](https://img.shields.io/badge/Duration-6--8_Weeks-7C3AED?style=flat-square)
![Difficulty](https://img.shields.io/badge/Difficulty-Expert-red?style=flat-square)
![Cost](https://img.shields.io/badge/Est._Cost-$500%2B/mo-lightgrey?style=flat-square)

</td>
</tr>
<tr>
<td align="center"><b>P05</b></td>
<td>

### 📡 [Smart City IoT Platform — Edge Computing](./project-05-iot-smart-city/README.md)

Connect 100K+ IoT devices with edge + cloud processing at sub-10ms latency.

**Core Services:**
`IoT Core` `Greengrass` `IoT Events` `Kinesis` `Timestream` `SNS` `Lambda@Edge` `Grafana AMG`

**What you'll learn:** IoT architecture, edge computing, time-series data, real-time alerting

![Duration](https://img.shields.io/badge/Duration-4--5_Weeks-FF4757?style=flat-square)
![Difficulty](https://img.shields.io/badge/Difficulty-Advanced-orange?style=flat-square)
![Cost](https://img.shields.io/badge/Est._Cost-$100--200/mo-lightgrey?style=flat-square)

</td>
</tr>
</table>

---

## 🚀 Getting Started

### Install Required Tools

```bash
# Windows (run PowerShell as Administrator)

# 1. AWS CLI
winget install Amazon.AWSCLI

# 2. AWS SAM CLI (for Serverless projects)
winget install Amazon.SAM-CLI

# 3. Git
winget install Git.Git

# Verify installations
aws --version
git --version
```

### Configure AWS CLI

```bash
aws configure
# AWS Access Key ID:     [your key from IAM Console]
# AWS Secret Access Key: [your secret key]
# Default region name:   us-east-1
# Default output format: json

# Verify connection
aws sts get-caller-identity
```

### Recommended Project Order

```
P01 → P02 → P05 → P03 → P04
(easiest to most complex)
```

---

## 📚 Prerequisites

Before starting any project, make sure you understand:

| Concept | Free Resource |
|---------|--------------|
| AWS Basics (IAM, VPC, EC2, S3) | [AWS Skill Builder Free](https://skillbuilder.aws/) |
| Networking Basics (IP, Subnets, DNS) | [AWS Networking Basics](https://aws.amazon.com/getting-started/) |
| Linux Command Line | [Linux Journey](https://linuxjourney.com/) |
| YAML/JSON for CloudFormation | Any basic YAML reference |

---

## 💰 Cost Estimates

> ⚠️ **Important:** Always use an **AWS Free Tier Account** for learning and stop resources when not in use.

| Project | Monthly Estimate | Free Tier Friendly? |
|---------|:---------------:|:-------------------:|
| P01 - Streaming | $150 - $300 | Partial ✦ |
| P02 - Banking | ~$0 | ✅ Yes |
| P03 - Data Lake | $200 - $400 | Partial ✦ |
| P04 - SaaS + DR | $500+ | ❌ No |
| P05 - IoT | $100 - $200 | Partial ✦ |

**Tip:** Start with P02 — it's nearly free. Then P01 and P05, activating resources only during practice sessions.

---

## 🗺️ Recommended Learning Path

```
Week 1-2    ──► AWS Fundamentals (IAM + VPC + EC2 + S3)
Week 3-5    ──► P01: Streaming Platform (CDN + Auto Scaling)
Week 6-9    ──► P02: Serverless Banking (Lambda + Security)
Week 10-13  ──► P05: IoT Smart City (IoT Core + Kinesis)
Week 14-19  ──► P03: Data Lake (Big Data + ML)
Week 20-27  ──► P04: SaaS + DR (Advanced Multi-Account)
Week 28     ──► Review + Take the Exam 🎯
```

---

## 📁 Repository Structure

```
aws-saa-c03-projects/
│
├── 📄 README.md                          ← You are here
├── 📄 CONTRIBUTING.md
├── 📄 .gitignore
│
├── 📁 project-01-streaming/
│   ├── 📄 README.md                      ← Full project guide
│   ├── 📁 architecture/                  ← Architecture files (draw.io)
│   ├── 📁 cloudformation/               ← IaC templates
│   │   ├── 01-vpc.yaml
│   │   ├── 02-s3-cloudfront.yaml
│   │   ├── 03-alb-autoscaling.yaml
│   │   └── 04-media-pipeline.yaml
│   ├── 📁 docs/                         ← Deep-dive docs per service
│   │   ├── 01-what-is-cloudfront.md
│   │   ├── 02-s3-deep-dive.md
│   │   └── 03-autoscaling-explained.md
│   ├── 📁 scripts/                      ← Deployment scripts
│   │   ├── deploy.ps1                   ← Windows PowerShell
│   │   └── cleanup.ps1
│   └── 📁 diagrams/                     ← Architecture images
│
├── 📁 project-02-serverless-banking/    ← Same structure
├── 📁 project-03-data-lake/             ← Same structure
├── 📁 project-04-saas-multitenant/      ← Same structure
├── 📁 project-05-iot-smart-city/        ← Same structure
│
└── 📁 .github/
    └── 📁 ISSUE_TEMPLATE/
        ├── bug_report.md
        └── question.md
```

---

## 🤝 Contributing

This project is for personal learning. If you find an error or want to suggest an improvement:

1. Open an **Issue** using the appropriate template
2. **Fork** the repo and make your changes
3. Open a **Pull Request** with a clear description

---

## 📜 License

This project is under the **MIT License** — free to use and share.

---

<div align="center">

**Built with ❤️ to prepare for the AWS SAA-C03 exam**

⭐ Don't forget to star this repo if it helped you!

</div>
