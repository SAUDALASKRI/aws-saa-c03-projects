# 🎬 المشروع الأول: منصة Streaming إعلامية عالية التوفر

<div align="center">

<img src="https://img.shields.io/badge/AWS-CloudFront-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-MediaLive-E7157B?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Auto_Scaling-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/Availability-99.99%25-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/نطاق_الامتحان-Resilient_Architectures-0095D5?style=for-the-badge"/>

</div>

---

## 🎯 هدف المشروع

بناء منصة بث مباشر وفيديو عند الطلب (VOD) تشبه Netflix أو MBC Shahid تتحمل:
- **ملايين المستخدمين المتزامنين**
- **Live streaming** بدون تأخير
- **99.99% uptime** = لا يزيد التوقف عن 52 دقيقة سنوياً
- **حماية DDoS** كاملة

---

## 🗺️ المعمارية الكاملة

```
المستخدم
    │
    ▼
┌─────────────────────────────────────┐
│  Route 53 (DNS + Health Checks)     │  ← يوجه المستخدم لأقرب منطقة
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  AWS WAF + Shield Advanced          │  ← يحمي من الهجمات
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  CloudFront (CDN - 400+ نقطة)       │  ← يسرّع التوصيل للمستخدم
│  - Cache للـ VOD                    │
│  - Signed URLs للمحتوى المحمي       │
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
      │  AZ-1a     │          │  AZ-1b     │  ← في منطقتين للـ HA
      └─────┬──────┘          └─────┬──────┘
            └──────────┬────────────┘
                       ▼
              ┌─────────────────┐
              │  ElastiCache    │  ← Cache للـ Sessions والـ API
              │  Redis Cluster  │
              └────────┬────────┘
                       │
              ┌────────┴────────┐
              ▼                 ▼
       ┌────────────┐   ┌────────────┐
       │  RDS Aurora│   │  DynamoDB  │
       │  Multi-AZ  │   │  (Metadata)│
       └────────────┘   └────────────┘

LIVE STREAMING PIPELINE:
مصدر البث → MediaLive → MediaPackage → CloudFront → المشاهدون
```

---

## 📚 شرح كل خدمة من الصفر

### 1️⃣ Amazon Route 53 — نظام أسماء النطاقات

**ما هو؟**
تخيل Route 53 كـ "دليل هاتف الإنترنت". عندما تكتب `www.shahid.net` في المتصفح، Route 53 هو الذي يترجم هذا الاسم إلى عنوان IP حقيقي.

**لماذا نستخدمه في المشروع؟**
- **Latency Routing:** يوجه المستخدم السعودي لـ server في البحرين، والأوروبي لـ server في أيرلندا
- **Health Checks:** إذا فشل server، Route 53 يوجه التراث تلقائياً للـ server الاحتياطي

**المصطلحات المهمة للامتحان:**
| المصطلح | المعنى |
|---------|--------|
| Hosted Zone | مجلد يحتوي على إعدادات نطاقك |
| Record Type A | يربط اسم النطاق بعنوان IPv4 |
| TTL | كم تُخزَّن النتيجة في الـ cache (بالثواني) |
| Failover Routing | التحويل التلقائي عند الفشل |
| Latency Routing | التوجيه لأقرب server |

---

### 2️⃣ AWS WAF + Shield — درع الحماية

**ما هو WAF؟**
WAF = Web Application Firewall. مثل حارس الأمن في المدخل — يفحص كل طلب قادم ويمنع الخطرة.

**ما هو Shield؟**
- **Shield Standard:** مجاني، يحمي من هجمات DDoS الأساسية تلقائياً
- **Shield Advanced:** مدفوع ($3000/شهر)، يحمي من هجمات ضخمة ويوفر فريق استجابة AWS

**مثال حقيقي:**
```
هجوم DDoS يرسل 10 مليون طلب/ثانية لموقعك
  → Shield يكتشف النمط غير الطبيعي
  → يعزل الـ traffic الخبيث
  → موقعك يبقى شغال للمستخدمين الحقيقيين ✅
```

**قواعد WAF الشائعة:**
- منع IP بلد معين
- منع طلبات تحتوي على SQL Injection
- Rate Limiting: منع أكثر من 1000 طلب/دقيقة من نفس الـ IP

---

### 3️⃣ Amazon CloudFront — شبكة توصيل المحتوى (CDN)

**المشكلة بدون CDN:**
```
مستخدم في الرياض يطلب فيديو
  → الطلب يذهب لـ server في أمريكا (تأخير 200ms)
  → Server يرسل الفيديو كاملاً عبر المحيط (بطيء جداً!)
```

**الحل مع CloudFront:**
```
مستخدم في الرياض يطلب نفس الفيديو
  → CloudFront يتحقق: هل الفيديو موجود في نقطة الحضور بالرياض؟
  → نعم → يرسله مباشرة (تأخير 5ms فقط!) ✅
  → لا → يجلبه من الـ origin مرة واحدة ويخزنه للمرات القادمة
```

**CloudFront لديه 400+ نقطة حضور (Edge Location) حول العالم!**

**المصطلحات المهمة:**
| المصطلح | المعنى |
|---------|--------|
| Origin | المصدر الأصلي للمحتوى (S3 أو ALB) |
| Edge Location | نقطة الحضور القريبة من المستخدم |
| Cache Hit | المحتوى موجود في الـ Cache (سريع) |
| Cache Miss | المحتوى غير موجود، يُجلب من الـ Origin (بطيء) |
| TTL | مدة بقاء الملف في الـ Cache |
| Signed URL | رابط مشفر ومحمي لمحتوى مدفوع |

**Behaviors في CloudFront:**
```
/videos/*     → Cache لمدة 24 ساعة (محتوى ثابت)
/api/*        → لا Cache (بيانات ديناميكية)
/live/*       → Redirect لـ MediaPackage
```

---

### 4️⃣ Amazon S3 — التخزين الأساسي

**ما هو S3؟**
مستودع تخزين لا نهائي. تخيله كـ Google Drive للمطورين — يخزن أي نوع ملف بأي حجم.

**في مشروع Streaming:**
```
s3://my-streaming-platform-videos/
├── raw/           ← الفيديوهات الأصلية بجودة عالية
├── processed/     ← نفس الفيديو بجودات مختلفة (1080p, 720p, 480p)
├── thumbnails/    ← الصور المصغرة
└── subtitles/     ← ملفات الترجمة
```

**Lifecycle Policies — توفير التكلفة:**
```
الفيديو الجديد (0-30 يوم)    → S3 Standard         ($0.023/GB)
الفيديو القديم (31-90 يوم)   → S3 Standard-IA      ($0.0125/GB)  توفير 45%
الأرشيف (91-365 يوم)         → S3 Glacier          ($0.004/GB)   توفير 82%
بعد سنة                      → حذف تلقائي           وفر مساحة
```

**Storage Classes مهمة للامتحان:**

| Class | الاستخدام | السعر النسبي |
|-------|-----------|:---:|
| Standard | بيانات يُصل إليها كثيراً | ████ |
| Standard-IA | بيانات نادرة الوصول | ██ |
| Glacier Instant | أرشيف، استرجاع فوري | █ |
| Glacier Flexible | أرشيف، استرجاع 1-12 ساعة | ▌ |
| Intelligent-Tiering | تحرك تلقائي بين الـ classes | ██ |

---

### 5️⃣ Application Load Balancer (ALB)

**ما هو؟**
موزع الحمل — مثل مدير الطابور في البنك يوجه كل عميل لأقرب موظف متاح.

**كيف يعمل:**
```
1000 مستخدم يطلبون الـ API في نفس اللحظة
       ↓
    ALB يوزعهم:
    Server 1 ← 334 مستخدم
    Server 2 ← 333 مستخدم
    Server 3 ← 333 مستخدم
       ↓
    لا يغرق أي server واحد ✅
```

**ALB vs NLB (للامتحان):**
| | ALB | NLB |
|--|-----|-----|
| Layer | Layer 7 (HTTP/HTTPS) | Layer 4 (TCP/UDP) |
| الاستخدام | تطبيقات ويب | Gaming, VoIP |
| يفهم | URL, Headers | IP, Port فقط |
| الـ Routing | بناء على المسار | بناء على الـ IP |

---

### 6️⃣ Auto Scaling Group (ASG)

**المشكلة:**
```
العادي:  100 مستخدم  → تحتاج 2 servers
رمضان:  10,000 مستخدم → تحتاج 200 server!
بعد رمضان: 100 مستخدم  → 200 server تبقى تأكل فلوس!
```

**الحل مع Auto Scaling:**
```
Minimum: 2 servers دائماً (لضمان الـ availability)
Desired: 5 servers في المعدل الطبيعي
Maximum: 200 servers في أوقات الذروة

↑ إذا CPU > 70% لمدة 5 دقائق → أضف 10 servers
↓ إذا CPU < 30% لمدة 10 دقائق → احذف 5 servers
```

**Scaling Policies:**
| النوع | كيف يعمل | متى تستخدمه |
|-------|-----------|-------------|
| Target Tracking | حافظ على CPU=60% تلقائياً | الأفضل للمبتدئين |
| Step Scaling | قواعد مخصصة (CPU>70% → +2) | تحكم أكثر |
| Scheduled | في رمضان زد الـ servers مسبقاً | أحداث متوقعة |
| Predictive | ML يتوقع ويزيد قبل الذروة | متقدم |

---

### 7️⃣ ElastiCache Redis — الذاكرة السريعة

**لماذا نحتاجه؟**
```
بدون Cache:
مستخدم يفتح الـ App → طلب للـ API → استعلام لـ Database (100ms)
مستخدم ثانٍ نفس الطلب → طلب للـ API → استعلام لـ Database (100ms) مرة ثانية!

مع Redis Cache:
مستخدم أول → API → Database (100ms) → نتيجة تُخزَّن في Redis
مستخدم ثانٍ → API → Redis (0.5ms) ✅ أسرع 200 مرة!
```

**في مشروع Streaming نستخدم Redis لـ:**
- تخزين الـ User Session (من سجّل دخول؟)
- تخزين قائمة "Top 10 Videos" (تتغير كل ساعة فقط)
- Rate Limiting (هذا المستخدم شاهد 3 إعلانات هذه الساعة)

---

### 8️⃣ AWS MediaLive + MediaConvert — خط إنتاج الفيديو

**MediaLive:** لـ Live Streaming
```
مصدر مباشر (كاميرا/بث) → MediaLive → يحوله لـ HLS → CloudFront → المشاهدون
```

**MediaConvert:** لـ VOD (فيديو عند الطلب)
```
ملف فيديو أصلي (4K, 10GB) → MediaConvert → 
  ├── 1080p.m3u8 (للـ TV)
  ├── 720p.m3u8  (للـ Laptop)
  ├── 480p.m3u8  (للـ Mobile)
  └── 360p.m3u8  (للاتصال البطيء)
→ تُخزَّن في S3 → CloudFront يوصلها
```

**Adaptive Bitrate Streaming:**
Netflix وShahid تستخدم هذا — المشغل يختار الجودة تلقائياً حسب سرعة اتصالك!

---

## 🛠️ خطوات التنفيذ التفصيلية

### المرحلة الأولى: الأساس (VPC والشبكة)

**الخطوة 1: إنشاء VPC**

```
AWS Console → VPC → Create VPC
Name: streaming-platform-vpc
CIDR: 10.0.0.0/16  (يتسع لـ 65,536 جهاز)
```

**لماذا CIDR = 10.0.0.0/16؟**
- الـ /16 يعني أول 16 bit ثابتة
- يعطيك 2^16 = 65,536 عنوان IP
- أكثر من كافٍ لمشروعنا

```
الـ Subnets:
Public Subnet 1 (us-east-1a):  10.0.1.0/24  ← ALB هنا
Public Subnet 2 (us-east-1b):  10.0.2.0/24  ← ALB الثاني
Private Subnet 1 (us-east-1a): 10.0.11.0/24 ← EC2 هنا
Private Subnet 2 (us-east-1b): 10.0.12.0/24 ← EC2 الثاني
```

**لماذا Public وPrivate؟**
- Public: يمكن الوصول إليه من الإنترنت (ALB)
- Private: محمي، لا يُرى من الإنترنت (Servers)

**الخطوة 2: Internet Gateway**
```
VPC → Internet Gateways → Create → Attach to VPC
```
Internet Gateway = "الباب" بين VPC والإنترنت

**الخطوة 3: NAT Gateway**
```
VPC → NAT Gateways → Create
Subnet: Public Subnet 1
Elastic IP: Allocate New
```
NAT Gateway يسمح لـ Private Servers بالوصول للإنترنت (للـ Updates) دون أن يُرَوا من الخارج

**الخطوة 4: Route Tables**
```
Public Route Table:
  0.0.0.0/0 → Internet Gateway (الإنترنت)

Private Route Table:
  0.0.0.0/0 → NAT Gateway (عبر الـ NAT)
```

---

### المرحلة الثانية: S3 + CloudFront

**الخطوة 5: إنشاء S3 Bucket**

```bash
# PowerShell على Windows
aws s3 mb s3://streaming-platform-videos-YOUR_ACCOUNT_ID \
  --region us-east-1

# تفعيل Versioning
aws s3api put-bucket-versioning \
  --bucket streaming-platform-videos-YOUR_ACCOUNT_ID \
  --versioning-configuration Status=Enabled
```

**لماذا Versioning؟**
إذا حذفت فيديو بالغلط، تقدر تسترجعه. مهم للـ Production.

**الخطوة 6: إعداد Lifecycle Policy**

```json
// حفظ الملف كـ lifecycle.json
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

```bash
aws s3api put-bucket-lifecycle-configuration \
  --bucket streaming-platform-videos-YOUR_ACCOUNT_ID \
  --lifecycle-configuration file://lifecycle.json
```

**الخطوة 7: إنشاء CloudFront Distribution**

```
CloudFront → Create Distribution:

Origin:
  Origin Domain: streaming-platform-videos-YOUR_ACCOUNT_ID.s3.us-east-1.amazonaws.com
  Origin Access: Origin Access Control (OAC) ← أمان أفضل من OAI
  
Default Cache Behavior:
  Viewer Protocol Policy: Redirect HTTP to HTTPS
  Cache Policy: CachingOptimized
  
Price Class: Use All Edge Locations (الأفضل للأداء)

WAF: Enable → Create new WAF
```

> 💡 **ملاحظة:** CloudFront يأخذ 15-20 دقيقة لينتشر حول العالم

---

### المرحلة الثالثة: ALB + Auto Scaling

**الخطوة 8: إنشاء Security Groups**

```
Security Group للـ ALB:
  Inbound:  Port 443 (HTTPS) من 0.0.0.0/0 (الإنترنت كله)
  Outbound: Port 8080 للـ EC2 فقط

Security Group للـ EC2:
  Inbound:  Port 8080 من ALB Security Group فقط (!)
  Outbound: كل شيء (للـ S3 وDatabase)
```

**لماذا نقيد الـ EC2؟**
لا أحد يستطيع الوصول للـ Servers مباشرة. فقط عبر ALB. هذا أمان ضروري.

**الخطوة 9: إنشاء Launch Template**

```
EC2 → Launch Templates → Create:

AMI: Amazon Linux 2023
Instance Type: t3.medium (2 vCPU, 4GB RAM)
Key Pair: أنشئ واحداً جديداً واحفظ الـ .pem
Security Group: EC2-SG

User Data (يُشغَّل عند بدء الـ Instance):
#!/bin/bash
yum update -y
yum install -y nodejs npm
npm install -g pm2
# هنا تضع كود تطبيقك
```

**الخطوة 10: إنشاء Auto Scaling Group**

```
EC2 → Auto Scaling Groups → Create:

Launch Template: الذي أنشأناه
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

### المرحلة الرابعة: Route 53 + WAF

**الخطوة 11: إعداد Route 53**

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

**الخطوة 12: WAF Rules**

```
WAF → Web ACLs → Create:
  Resource: CloudFront Distribution
  
Add Rules:
  1. AWSManagedRulesCommonRuleSet     ← يمنع OWASP Top 10
  2. AWSManagedRulesKnownBadInputsRuleSet ← يمنع SQL Injection
  3. Custom Rate Limit: 2000 req/5min per IP
```

---

### المرحلة الخامسة: Media Pipeline (Live Streaming)

**الخطوة 13: إعداد MediaLive**

```
MediaLive → Channels → Create:
  Input: RTMP (من برنامج البث مثل OBS)
  Output: HLS → S3 → CloudFront
  
Settings:
  Output Groups → HLS:
    Segment Length: 6 seconds
    Destination: s3://streaming-platform-videos/live/
```

**الخطوة 14: MediaConvert للـ VOD**

```python
# سكريبت Python لإرسال فيديو للمعالجة
import boto3

mediaconvert = boto3.client('mediaconvert', region_name='us-east-1')

job = mediaconvert.create_job(
    Role='arn:aws:iam::ACCOUNT_ID:role/MediaConvertRole',
    Settings={
        'Inputs': [{
            'FileInput': 's3://streaming-platform-videos/raw/movie.mp4'
        }],
        'OutputGroups': [{
            'OutputGroupSettings': {
                'Type': 'HLS_GROUP_SETTINGS',
                'HlsGroupSettings': {
                    'Destination': 's3://streaming-platform-videos/processed/movie/'
                }
            },
            'Outputs': [
                {'VideoDescription': {'Width': 1920, 'Height': 1080}},  # 1080p
                {'VideoDescription': {'Width': 1280, 'Height': 720}},   # 720p
                {'VideoDescription': {'Width': 854,  'Height': 480}},   # 480p
            ]
        }]
    }
)

print(f"Job created: {job['Job']['Id']}")
```

---

## 📊 CloudFormation Template — النشر التلقائي

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
  # VPC الرئيسي
  StreamingVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: !Sub '${Environment}-streaming-vpc'

  # Public Subnets
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

  # Private Subnets
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

  # Internet Gateway
  InternetGateway:
    Type: AWS::EC2::InternetGateway

  VPCGatewayAttachment:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref StreamingVPC
      InternetGatewayId: !Ref InternetGateway

  # NAT Gateway
  NatEIP:
    Type: AWS::EC2::EIP
    Properties:
      Domain: vpc

  NatGateway:
    Type: AWS::EC2::NatGateway
    Properties:
      AllocationId: !GetAtt NatEIP.AllocationId
      SubnetId: !Ref PublicSubnet1

  # Route Tables
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

## 🪟 سكريبت النشر (Windows PowerShell)

```powershell
# scripts/deploy.ps1

param(
    [string]$Environment = "dev",
    [string]$Region = "us-east-1",
    [string]$AccountId = (aws sts get-caller-identity --query Account --output text)
)

Write-Host "🚀 بدء نشر Streaming Platform - بيئة: $Environment" -ForegroundColor Cyan

# الخطوة 1: نشر VPC
Write-Host "`n📦 الخطوة 1: إنشاء VPC..." -ForegroundColor Yellow
aws cloudformation deploy `
    --template-file cloudformation/01-vpc.yaml `
    --stack-name "$Environment-streaming-vpc" `
    --parameter-overrides Environment=$Environment `
    --region $Region

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ فشل إنشاء VPC!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ VPC جاهز!" -ForegroundColor Green

# الخطوة 2: إنشاء S3 Bucket
Write-Host "`n📦 الخطوة 2: إنشاء S3 Bucket..." -ForegroundColor Yellow
$BucketName = "streaming-platform-videos-$AccountId-$Environment"
aws s3 mb "s3://$BucketName" --region $Region
aws s3api put-bucket-versioning `
    --bucket $BucketName `
    --versioning-configuration Status=Enabled

Write-Host "✅ S3 Bucket جاهز: $BucketName" -ForegroundColor Green

Write-Host "`n🎉 تم النشر بنجاح!" -ForegroundColor Cyan
Write-Host "CloudFront URL سيظهر بعد 15-20 دقيقة" -ForegroundColor Gray
```

---

## 🧪 أسئلة امتحان SAA-C03 المتوقعة

> هذه أنماط أسئلة حقيقية من الامتحان:

**❓ السؤال 1:**
شركة تريد تقليل تأخير تحميل الفيديو لمستخدمين في 50 دولة. ما الحل الأمثل؟

**✅ الجواب:** Amazon CloudFront مع Edge Locations — يخزن المحتوى قريباً من كل مستخدم

---

**❓ السؤال 2:**
موقع streaming يتوقع زيادة 10x في الزوار خلال رمضان. كيف تضمن الأداء مع تقليل التكلفة باقي السنة؟

**✅ الجواب:** Auto Scaling Group مع Scheduled Scaling (زيادة تلقائية في رمضان) + Spot Instances للتوفير

---

**❓ السؤال 3:**
فيديوهات مدفوعة يجب أن لا تُشاهَد بدون اشتراك. كيف تحميها في CloudFront؟

**✅ الجواب:** CloudFront Signed URLs أو Signed Cookies — روابط مشفرة تنتهي صلاحيتها

---

**❓ السؤال 4:**
تريد تقليل تكلفة تخزين فيديوهات عمرها أكثر من سنة لكن لا تريد حذفها.

**✅ الجواب:** S3 Lifecycle Policy → بعد 365 يوم → S3 Glacier Deep Archive

---

## ✅ قائمة التحقق النهائية

```
Infrastructure:
□ VPC مع Public/Private Subnets في Availability Zone مختلفتين
□ Internet Gateway + NAT Gateway
□ Route Tables صحيحة لكل Subnet
□ Security Groups محدودة (Least Privilege)

CDN & Storage:
□ S3 Bucket مع Versioning وLifecycle Policy
□ CloudFront مع OAC (Origin Access Control)
□ HTTPS مفعّل بشكل إجباري
□ WAF مرتبط بـ CloudFront

Compute:
□ Launch Template بـ User Data صحيح
□ Auto Scaling Group في Private Subnets
□ ALB في Public Subnets
□ Target Group بـ Health Checks

Monitoring:
□ CloudWatch Dashboard للـ Metrics الرئيسية
□ Alarms على CPU, ALB 5xx, Cache Hit Rate
□ CloudTrail مفعّل لتتبع كل API calls

Cost:
□ S3 Intelligent-Tiering للـ Objects غير المعروفة الاستخدام
□ Reserved Instances للـ EC2 الثابتة
□ Cost Budget بـ Alert عند 80%
```

---

## 📎 موارد إضافية

- 📖 [AWS CloudFront Developer Guide](https://docs.aws.amazon.com/cloudfront/)
- 📖 [Auto Scaling Best Practices](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-best-practices.html)
- 🎥 [AWS re:Invent: Building Video Streaming Platforms](https://www.youtube.com/aws)
- 🧪 [AWS Free Tier Limits](https://aws.amazon.com/free/)

---

<div align="center">

[⬅️ العودة للرئيسية](../README.md) | [➡️ المشروع الثاني: Serverless Banking](../project-02-serverless-banking/README.md)

</div>
