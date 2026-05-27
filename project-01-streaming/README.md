# 🎬 Project 01: High-Availability Media Streaming Platform

<div align="center">

<img src="https://img.shields.io/badge/AWS-CloudFront-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-MediaLive-E7157B?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Auto_Scaling-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/Availability-99.99%25-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Exam_Domain-Resilient_Architectures-0095D5?style=for-the-badge"/>

</div>

---

## 🎯 Project Goal

Build a live streaming and Video-on-Demand (VOD) platform similar to Netflix or YouTube that can handle:
- **Millions of concurrent users**
- **Live streaming** with no buffering
- **99.99% uptime** = less than 52 minutes of downtime per year
- **Full DDoS protection**

---

## 🗺️ Full Architecture

```
User
 │
 ▼
┌─────────────────────────────────────┐
│  Route 53 (DNS + Health Checks)     │  ← Routes user to nearest region
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  AWS WAF + Shield Advanced          │  ← Protects against attacks
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  CloudFront (CDN - 400+ locations)  │  ← Delivers content fast
│  - Caches VOD content               │
│  - Signed URLs for protected content│
└──────────┬──────────────────────────┘
           │
    ┌──────┴──────┐
    ▼             ▼
┌───────┐    ┌────────────────────────┐
│  S3   │    │  Application Load      │
│ (VOD  │    │  Balancer (ALB)        │
│Content│    └────────────┬───────────┘
│ Files)│                 │
└───────┘    ┌────────────┴───────────┐
             ▼                        ▼
      ┌────────────┐          ┌────────────┐
      │  EC2 ASG   │          │  EC2 ASG   │
      │  AZ-1a     │          │  AZ-1b     │  ← Two AZs for HA
      └─────┬──────┘          └─────┬──────┘
            └──────────┬────────────┘
                       ▼
              ┌─────────────────┐
              │  ElastiCache    │  ← Sessions + API cache
              │  Redis Cluster  │
              └────────┬────────┘
                       │
              ┌────────┴────────┐
              ▼                 ▼
       ┌────────────┐   ┌────────────┐
       │  RDS Aurora│   │  DynamoDB  │
       │  Multi-AZ  │   │ (Metadata) │
       └────────────┘   └────────────┘

LIVE STREAMING PIPELINE:
Source → MediaLive → MediaPackage → CloudFront → Viewers
```

---

## 📚 Service Breakdown — From Scratch

### 1️⃣ Amazon Route 53 — DNS Service

**What is it?**
Think of Route 53 as the "phone book of the internet." When you type `www.myplatform.com`, Route 53 translates that name into a real IP address.

**Why we use it in this project:**
- **Latency Routing:** Routes a Saudi user to the Bahrain server, and a European user to the Ireland server
- **Health Checks:** If a server fails, Route 53 automatically redirects traffic to the backup server

**Key SAA-C03 Terms:**

| Term | Meaning |
|------|---------|
| Hosted Zone | A container for your domain's DNS records |
| A Record | Maps a domain name to an IPv4 address |
| TTL | How long a result is cached (in seconds) |
| Failover Routing | Automatic rerouting when primary fails |
| Latency Routing | Routes to the nearest/fastest server |

---

### 2️⃣ AWS WAF + Shield — Protection Layer

**What is WAF?**
WAF = Web Application Firewall. Like a security guard at the entrance — it inspects every incoming request and blocks dangerous ones.

**What is Shield?**
- **Shield Standard:** Free, automatically protects against basic DDoS attacks
- **Shield Advanced:** Paid ($3,000/mo), protects against large-scale attacks with an AWS response team

**Real-world example:**
```
A DDoS attack sends 10 million requests/second to your site
  → Shield detects the abnormal pattern
  → Isolates malicious traffic
  → Your site stays online for real users ✅
```

**Common WAF Rules:**
- Block traffic from specific countries
- Block requests containing SQL Injection patterns
- Rate Limiting: block more than 1,000 requests/minute from one IP

---

### 3️⃣ Amazon CloudFront — Content Delivery Network (CDN)

**The problem without a CDN:**
```
User in Riyadh requests a video
  → Request travels to a server in the US (200ms latency)
  → Server sends the full video across the ocean (very slow!)
```

**The solution with CloudFront:**
```
User in Riyadh requests the same video
  → CloudFront checks: is the video cached at the Riyadh edge location?
  → YES → Delivers immediately (only 5ms latency!) ✅
  → NO  → Fetches from origin once, caches it for future requests
```

**CloudFront has 400+ Edge Locations worldwide!**

**Key Terms:**

| Term | Meaning |
|------|---------|
| Origin | The original source of content (S3 or ALB) |
| Edge Location | The nearby point of presence serving the user |
| Cache Hit | Content found in cache (fast) |
| Cache Miss | Content not in cache, fetched from origin (slower) |
| TTL | How long a file stays in cache |
| Signed URL | An encrypted, time-limited link for protected content |

**CloudFront Behaviors:**
```
/videos/*  → Cache for 24 hours (static content)
/api/*     → No cache (dynamic data)
/live/*    → Redirect to MediaPackage
```

---

### 4️⃣ Amazon S3 — Core Storage

**What is it?**
An infinite storage repository. Think of it as Google Drive for developers — stores any file type, any size.

**In our streaming project:**
```
s3://my-streaming-platform-videos/
├── raw/           ← Original high-quality video files
├── processed/     ← Same video in multiple qualities (1080p, 720p, 480p)
├── thumbnails/    ← Preview images
└── subtitles/     ← Subtitle/caption files
```

**Lifecycle Policies — Cut Costs:**
```
New video  (0-30 days)    → S3 Standard      ($0.023/GB)
Older video (31-90 days)  → S3 Standard-IA   ($0.0125/GB)  45% savings
Archive    (91-365 days)  → S3 Glacier        ($0.004/GB)   82% savings
After 1 year              → Auto-delete        Free up space
```

**Storage Classes for the Exam:**

| Class | Use Case | Relative Cost |
|-------|----------|:-------------:|
| Standard | Frequently accessed data | ████ |
| Standard-IA | Infrequently accessed | ██ |
| Glacier Instant | Archive, instant retrieval | █ |
| Glacier Flexible | Archive, 1-12 hr retrieval | ▌ |
| Intelligent-Tiering | Auto-moves between classes | ██ |

---

### 5️⃣ Application Load Balancer (ALB)

**What is it?**
A load balancer distributes incoming traffic across multiple servers — like a bank teller directing customers to available windows.

**How it works:**
```
1,000 users hit the API at the same time
       ↓
    ALB distributes:
    Server 1 ← 334 users
    Server 2 ← 333 users
    Server 3 ← 333 users
       ↓
    No single server gets overwhelmed ✅
```

**ALB vs NLB (for the exam):**

| | ALB | NLB |
|--|-----|-----|
| Layer | Layer 7 (HTTP/HTTPS) | Layer 4 (TCP/UDP) |
| Use Case | Web applications | Gaming, VoIP |
| Understands | URL, Headers | IP and Port only |
| Routing | Path-based | IP-based |

---

### 6️⃣ Auto Scaling Group (ASG)

**The problem:**
```
Normal:   100 users   → need 2 servers
Ramadan:  10,000 users → need 200 servers!
After:    100 users   → 200 servers sitting idle, wasting money!
```

**The solution with Auto Scaling:**
```
Minimum: 2 servers always (guarantees availability)
Desired: 5 servers on average
Maximum: 200 servers during peak

↑ If CPU > 70% for 5 minutes → add 10 servers
↓ If CPU < 30% for 10 minutes → remove 5 servers
```

**Scaling Policy Types:**

| Type | How it works | When to use |
|------|-------------|-------------|
| Target Tracking | Keep CPU at 60% automatically | Best for beginners |
| Step Scaling | Custom rules (CPU > 70% → +2) | More control |
| Scheduled | Scale up before Ramadan/events | Predictable events |
| Predictive | ML predicts and scales proactively | Advanced |

---

### 7️⃣ ElastiCache Redis — In-Memory Speed Layer

**Why do we need it?**
```
Without cache:
User opens app → API call → Database query (100ms)
Second user, same request → API call → Database query (100ms) again!

With Redis cache:
First user  → API → Database (100ms) → result stored in Redis
Second user → API → Redis (0.5ms) ✅  200x faster!
```

**In our streaming project, Redis stores:**
- User session data (who is logged in?)
- "Top 10 Videos" list (only changes once per hour)
- Rate limiting (this user has seen 3 ads this hour)

---

### 8️⃣ AWS MediaLive + MediaConvert — Video Processing

**MediaLive:** For Live Streaming
```
Live source (camera/stream) → MediaLive → HLS output → CloudFront → Viewers
```

**MediaConvert:** For Video on Demand (VOD)
```
Original video (4K, 10GB) → MediaConvert →
  ├── 1080p.m3u8  (for TV)
  ├── 720p.m3u8   (for Laptop)
  ├── 480p.m3u8   (for Mobile)
  └── 360p.m3u8   (for slow connections)
→ Stored in S3 → Delivered via CloudFront
```

**Adaptive Bitrate Streaming:**
Netflix and YouTube use this — the player automatically adjusts quality based on your connection speed.

---

## 🛠️ Step-by-Step Implementation

### Phase 1: Foundation (VPC & Networking)

**Step 1: Create VPC**

```
AWS Console → VPC → Create VPC
Name: streaming-platform-vpc
CIDR: 10.0.0.0/16  (supports 65,536 devices)
```

**Why CIDR = 10.0.0.0/16?**
- /16 means the first 16 bits are fixed
- Gives you 2^16 = 65,536 IP addresses
- More than enough for our project

```
Subnets:
Public Subnet 1  (us-east-1a): 10.0.1.0/24  ← ALB lives here
Public Subnet 2  (us-east-1b): 10.0.2.0/24  ← Second ALB
Private Subnet 1 (us-east-1a): 10.0.11.0/24 ← EC2 servers
Private Subnet 2 (us-east-1b): 10.0.12.0/24 ← EC2 servers
```

**Why Public AND Private?**
- Public: accessible from the internet (ALB)
- Private: protected, not visible from the internet (Servers)

**Step 2: Internet Gateway**
```
VPC → Internet Gateways → Create → Attach to VPC
```
Internet Gateway = the "door" between your VPC and the internet

**Step 3: NAT Gateway**
```
VPC → NAT Gateways → Create
Subnet: Public Subnet 1
Elastic IP: Allocate New
```
NAT Gateway allows private servers to reach the internet (for updates) without being reachable from outside.

**Step 4: Route Tables**
```
Public Route Table:
  0.0.0.0/0 → Internet Gateway

Private Route Table:
  0.0.0.0/0 → NAT Gateway
```

---

### Phase 2: S3 + CloudFront

**Step 5: Create S3 Bucket**

```powershell
# Windows PowerShell
aws s3 mb s3://streaming-platform-videos-YOUR_ACCOUNT_ID `
  --region us-east-1

# Enable Versioning
aws s3api put-bucket-versioning `
  --bucket streaming-platform-videos-YOUR_ACCOUNT_ID `
  --versioning-configuration Status=Enabled
```

**Why Versioning?**
If you accidentally delete a video, you can restore it. Essential for production.

**Step 6: Set Up Lifecycle Policy**

```json
{
  "Rules": [
    {
      "ID": "move-old-videos-to-cheaper-storage",
      "Status": "Enabled",
      "Filter": {"Prefix": "processed/"},
      "Transitions": [
        {"Days": 30,  "StorageClass": "STANDARD_IA"},
        {"Days": 90,  "StorageClass": "GLACIER"},
        {"Days": 365, "StorageClass": "DEEP_ARCHIVE"}
      ]
    }
  ]
}
```

```powershell
aws s3api put-bucket-lifecycle-configuration `
  --bucket streaming-platform-videos-YOUR_ACCOUNT_ID `
  --lifecycle-configuration file://lifecycle.json
```

**Step 7: Create CloudFront Distribution**

```
CloudFront → Create Distribution:

Origin:
  Origin Domain: your-bucket.s3.us-east-1.amazonaws.com
  Origin Access: Origin Access Control (OAC)

Default Cache Behavior:
  Viewer Protocol Policy: Redirect HTTP to HTTPS
  Cache Policy: CachingOptimized

Price Class: Use All Edge Locations

WAF: Enable → Create new WAF
```

> 💡 **Note:** CloudFront takes 15–20 minutes to propagate globally

---

### Phase 3: ALB + Auto Scaling

**Step 8: Create Security Groups**

```
ALB Security Group:
  Inbound:  Port 443 (HTTPS) from 0.0.0.0/0
  Outbound: Port 8080 to EC2 only

EC2 Security Group:
  Inbound:  Port 8080 from ALB Security Group only (!)
  Outbound: Everything (for S3 and Database access)
```

**Why restrict EC2?**
No one can reach the servers directly — only through the ALB. This is essential security.

**Step 9: Create Launch Template**

```
EC2 → Launch Templates → Create:

AMI: Amazon Linux 2023
Instance Type: t3.medium (2 vCPU, 4GB RAM)
Key Pair: Create new, save the .pem file
Security Group: EC2-SG

User Data (runs on instance start):
#!/bin/bash
yum update -y
yum install -y nodejs npm
npm install -g pm2
```

**Step 10: Create Auto Scaling Group**

```
EC2 → Auto Scaling Groups → Create:

Launch Template: the one we created
VPC: streaming-platform-vpc
Subnets: Private-1a, Private-1b

Capacity:
  Minimum: 2
  Desired: 2
  Maximum: 10

Scaling Policy:
  Target Tracking → CPU = 60%
```

---

### Phase 4: Route 53 + WAF

**Step 11: Configure Route 53**

```
Route 53 → Hosted Zones → Create Hosted Zone:
  Domain: yourplatform.com

Records:
  www → ALIAS → CloudFront Distribution
  api → ALIAS → ALB

Health Check:
  Protocol: HTTPS
  Path: /health
  Threshold: 3 failures → Unhealthy
```

**Step 12: WAF Rules**

```
WAF → Web ACLs → Create:
  Resource: CloudFront Distribution

Add Rules:
  1. AWSManagedRulesCommonRuleSet       ← Blocks OWASP Top 10
  2. AWSManagedRulesKnownBadInputsRuleSet ← Blocks SQL Injection
  3. Custom Rate Limit: 2000 req/5min per IP
```

---

## 📊 CloudFormation Template

```yaml
# cloudformation/01-vpc.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Streaming Platform - VPC Infrastructure'

Parameters:
  Environment:
    Type: String
    Default: dev
    AllowedValues: [dev, staging, prod]

Resources:
  StreamingVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: !Sub '${Environment}-streaming-vpc'

  PublicSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref StreamingVPC
      CidrBlock: 10.0.1.0/24
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub '${Environment}-public-1'

  PublicSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref StreamingVPC
      CidrBlock: 10.0.2.0/24
      AvailabilityZone: !Select [1, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub '${Environment}-public-2'

  PrivateSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref StreamingVPC
      CidrBlock: 10.0.11.0/24
      AvailabilityZone: !Select [0, !GetAZs '']
      Tags:
        - Key: Name
          Value: !Sub '${Environment}-private-1'

  PrivateSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref StreamingVPC
      CidrBlock: 10.0.12.0/24
      AvailabilityZone: !Select [1, !GetAZs '']
      Tags:
        - Key: Name
          Value: !Sub '${Environment}-private-2'

  InternetGateway:
    Type: AWS::EC2::InternetGateway

  VPCGatewayAttachment:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref StreamingVPC
      InternetGatewayId: !Ref InternetGateway

  NatEIP:
    Type: AWS::EC2::EIP
    Properties:
      Domain: vpc

  NatGateway:
    Type: AWS::EC2::NatGateway
    Properties:
      AllocationId: !GetAtt NatEIP.AllocationId
      SubnetId: !Ref PublicSubnet1

  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref StreamingVPC

  PublicRoute:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref InternetGateway

  PrivateRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref StreamingVPC

  PrivateRoute:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PrivateRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      NatGatewayId: !Ref NatGateway

Outputs:
  VpcId:
    Value: !Ref StreamingVPC
    Export:
      Name: !Sub '${Environment}-VpcId'

  PublicSubnets:
    Value: !Join [',', [!Ref PublicSubnet1, !Ref PublicSubnet2]]
    Export:
      Name: !Sub '${Environment}-PublicSubnets'

  PrivateSubnets:
    Value: !Join [',', [!Ref PrivateSubnet1, !Ref PrivateSubnet2]]
    Export:
      Name: !Sub '${Environment}-PrivateSubnets'
```

---

## 🪟 Deployment Script (Windows PowerShell)

```powershell
# scripts/deploy.ps1
param(
    [string]$Environment = "dev",
    [string]$Region = "us-east-1",
    [string]$AccountId = (aws sts get-caller-identity --query Account --output text)
)

Write-Host "Deploying Streaming Platform - Environment: $Environment" -ForegroundColor Cyan

Write-Host "Step 1: Creating VPC..." -ForegroundColor Yellow
aws cloudformation deploy `
    --template-file cloudformation/01-vpc.yaml `
    --stack-name "$Environment-streaming-vpc" `
    --parameter-overrides Environment=$Environment `
    --region $Region

if ($LASTEXITCODE -ne 0) { Write-Host "VPC creation failed!" -ForegroundColor Red; exit 1 }
Write-Host "VPC ready!" -ForegroundColor Green

Write-Host "Step 2: Creating S3 Bucket..." -ForegroundColor Yellow
$BucketName = "streaming-platform-videos-$AccountId-$Environment"
aws s3 mb "s3://$BucketName" --region $Region
aws s3api put-bucket-versioning `
    --bucket $BucketName `
    --versioning-configuration Status=Enabled

Write-Host "Deployment complete!" -ForegroundColor Cyan
```

---

## 🧪 Expected SAA-C03 Exam Questions

**Question 1:**
A company wants to reduce video loading latency for users in 50 countries. What is the best solution?

**Answer:** Amazon CloudFront with Edge Locations — caches content close to every user.

---

**Question 2:**
A streaming site expects 10x traffic during Ramadan. How do you ensure performance while minimizing cost the rest of the year?

**Answer:** Auto Scaling Group with Scheduled Scaling (scale up before Ramadan) + Spot Instances for cost savings.

---

**Question 3:**
Paid videos must not be viewable without a subscription. How do you protect them in CloudFront?

**Answer:** CloudFront Signed URLs or Signed Cookies — encrypted links with expiry times.

---

**Question 4:**
You want to reduce storage costs for videos older than one year without deleting them.

**Answer:** S3 Lifecycle Policy → After 365 days → S3 Glacier Deep Archive.

---

## ✅ Final Checklist

```
Infrastructure:
□ VPC with Public/Private Subnets across two Availability Zones
□ Internet Gateway + NAT Gateway
□ Correct Route Tables for each subnet
□ Security Groups following Least Privilege principle

CDN & Storage:
□ S3 Bucket with Versioning and Lifecycle Policy
□ CloudFront with OAC (Origin Access Control)
□ HTTPS enforced
□ WAF attached to CloudFront

Compute:
□ Launch Template with correct User Data
□ Auto Scaling Group in Private Subnets
□ ALB in Public Subnets
□ Target Group with Health Checks

Monitoring:
□ CloudWatch Dashboard for key metrics
□ Alarms for CPU, ALB 5xx errors, Cache Hit Rate
□ CloudTrail enabled for API call tracking

Cost:
□ S3 Intelligent-Tiering for unknown-access objects
□ Reserved Instances for stable EC2
□ Cost Budget with 80% alert
```

---

<div align="center">

[⬅️ Back to Main](../README.md) | [➡️ Project 02: Serverless Banking](../project-02-serverless-banking/README.md)

</div>
