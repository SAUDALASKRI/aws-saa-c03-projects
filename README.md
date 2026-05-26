<div align="center">

```
 █████╗ ██╗    ██╗███████╗    ███████╗ █████╗  █████╗      ██████╗ ██████╗ ██████╗
██╔══██╗██║    ██║██╔════╝    ██╔════╝██╔══██╗██╔══██╗    ██╔════╝██╔═══██╗╚════██╗
███████║██║ █╗ ██║███████╗    ███████╗███████║███████║    ██║     ██║   ██║ █████╔╝
██╔══██║██║███╗██║╚════██║    ╚════██║██╔══██║██╔══██║    ██║     ██║   ██║ ╚═══██╗
██║  ██║╚███╔███╔╝███████║    ███████║██║  ██║██║  ██║    ╚██████╗╚██████╔╝██████╔╝
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚═════╝
```

# 🏗️ خمسة مشاريع متكاملة | AWS Solutions Architect Associate — SAA-C03

<img src="https://img.shields.io/badge/AWS-SAA--C03-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white"/>
<img src="https://img.shields.io/badge/مستوى-مبتدئ_إلى_متقدم-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/خدمات_AWS-30%2B-00B4D8?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/IaC-CloudFormation-FF4757?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/تغطية_الامتحان-~80%25-7C3AED?style=for-the-badge"/>

> **دليل عملي شامل** لبناء بنى تحتية حقيقية على AWS من الصفر حتى الإنتاج.  
> كل مشروع مشروح خطوة بخطوة مع كود CloudFormation جاهز للنشر.

</div>

---

## 📋 جدول المحتويات

- [🎯 نظرة عامة على نطاقات الامتحان](#-نظرة-عامة-على-نطاقات-الامتحان)
- [🗂️ المشاريع الخمسة](#️-المشاريع-الخمسة)
- [🚀 كيف تبدأ](#-كيف-تبدأ)
- [📚 متطلبات أساسية](#-متطلبات-أساسية)
- [💰 تقدير التكاليف](#-تقدير-التكاليف)
- [🗺️ خارطة التعلم المقترحة](#️-خارطة-التعلم-المقترحة)
- [🤝 المساهمة](#-المساهمة)

---

## 🎯 نظرة عامة على نطاقات الامتحان

امتحان SAA-C03 يتضمن **4 نطاقات رئيسية**. مشاريعنا تغطي كل نطاق:

| النطاق | الوزن في الامتحان | المشاريع المغطِّية |
|--------|:---:|---|
| 🔵 **Design Secure Architectures** | 30% | P02 ✦ P04 |
| 🟠 **Design Resilient Architectures** | 26% | P01 ✦ P04 |
| 🟢 **Design High-Performing Architectures** | 24% | P01 ✦ P03 ✦ P05 |
| 🟡 **Design Cost-Optimized Architectures** | 20% | P02 ✦ P03 ✦ P05 |

---

## 🗂️ المشاريع الخمسة

<table>
<tr>
<td width="60px" align="center"><b>P01</b></td>
<td>

### 🎬 [منصة Streaming إعلامية عالية التوفر](./project-01-streaming/README.md)

بناء CDN + Live Streaming يتحمل ملايين المستخدمين بـ 99.99% uptime

**الخدمات الرئيسية:**
`CloudFront` `S3` `MediaLive` `MediaConvert` `ALB` `Auto Scaling` `Route 53` `WAF` `ElastiCache`

**ما ستتعلمه:** Multi-Region, CDN Caching, DDoS Protection, Auto Scaling Policies

![مدة التنفيذ](https://img.shields.io/badge/المدة-3--4_أسابيع-FF9900?style=flat-square)
![الصعوبة](https://img.shields.io/badge/الصعوبة-Advanced-orange?style=flat-square)
![التكلفة](https://img.shields.io/badge/التكلفة-$150--300/شهر-lightgrey?style=flat-square)

</td>
</tr>
<tr>
<td align="center"><b>P02</b></td>
<td>

### 🏦 [نظام بنكي Serverless آمن ومتوافق](./project-02-serverless-banking/README.md)

معاملات مالية بدون سيرفرات مع PCI-DSS compliance كامل

**الخدمات الرئيسية:**
`Lambda` `API Gateway` `DynamoDB` `Cognito` `KMS` `SQS` `Step Functions` `GuardDuty` `CloudTrail`

**ما ستتعلمه:** Serverless Architecture, Encryption at Rest/Transit, Audit Logging, Event-Driven Design

![مدة التنفيذ](https://img.shields.io/badge/المدة-4--5_أسابيع-00D084?style=flat-square)
![الصعوبة](https://img.shields.io/badge/الصعوبة-Expert-red?style=flat-square)
![التكلفة](https://img.shields.io/badge/التكلفة-~$0_Free_Tier-lightgrey?style=flat-square)

</td>
</tr>
<tr>
<td align="center"><b>P03</b></td>
<td>

### 📊 [منصة تحليلات بيانات ضخمة — Data Lake](./project-03-data-lake/README.md)

تحليل Petabytes من البيانات مع ML pipeline ورؤى real-time

**الخدمات الرئيسية:**
`S3` `Glue` `Athena` `Kinesis` `EMR` `Redshift` `SageMaker` `QuickSight` `Lake Formation`

**ما ستتعلمه:** Medallion Architecture, ETL Pipelines, Data Cataloging, ML on AWS

![مدة التنفيذ](https://img.shields.io/badge/المدة-5--6_أسابيع-00B4D8?style=flat-square)
![الصعوبة](https://img.shields.io/badge/الصعوبة-Expert-red?style=flat-square)
![التكلفة](https://img.shields.io/badge/التكلفة-$200--400/شهر-lightgrey?style=flat-square)

</td>
</tr>
<tr>
<td align="center"><b>P04</b></td>
<td>

### 🏢 [منصة SaaS متعددة المستأجرين + Disaster Recovery](./project-04-saas-multitenant/README.md)

SaaS enterprise مع RTO < 15 دقيقة وعزل تام بين العملاء

**الخدمات الرئيسية:**
`Organizations` `Control Tower` `EKS` `Aurora Global` `AWS Backup` `DRS` `Transit Gateway` `RAM`

**ما ستتعلمه:** Multi-Account Strategy, Kubernetes on AWS, Global Database, DR Testing

![مدة التنفيذ](https://img.shields.io/badge/المدة-6--8_أسابيع-7C3AED?style=flat-square)
![الصعوبة](https://img.shields.io/badge/الصعوبة-Expert-red?style=flat-square)
![التكلفة](https://img.shields.io/badge/التكلفة-$500%2B/شهر-lightgrey?style=flat-square)

</td>
</tr>
<tr>
<td align="center"><b>P05</b></td>
<td>

### 📡 [منصة IoT ذكية للمدن — Edge Computing](./project-05-iot-smart-city/README.md)

ربط 100K+ جهاز IoT بمعالجة Edge وCloud بزمن < 10ms

**الخدمات الرئيسية:**
`IoT Core` `Greengrass` `IoT Events` `Kinesis` `Timestream` `SNS` `Lambda@Edge` `Grafana AMG`

**ما ستتعلمه:** IoT Architecture, Edge Computing, Time-Series Data, Real-time Alerting

![مدة التنفيذ](https://img.shields.io/badge/المدة-4--5_أسابيع-FF4757?style=flat-square)
![الصعوبة](https://img.shields.io/badge/الصعوبة-Advanced-orange?style=flat-square)
![التكلفة](https://img.shields.io/badge/التكلفة-$100--200/شهر-lightgrey?style=flat-square)

</td>
</tr>
</table>

---

## 🚀 كيف تبدأ

### المتطلبات المسبقة

```bash
# 1. تثبيت AWS CLI
# Windows (PowerShell كمسؤول):
winget install Amazon.AWSCLI

# التحقق من التثبيت:
aws --version

# 2. تثبيت AWS SAM CLI (للـ Serverless)
winget install Amazon.SAM-CLI

# 3. تثبيت Git
winget install Git.Git
```

### إعداد بيئة العمل

```bash
# استنساخ المشروع
git clone https://github.com/YOUR_USERNAME/aws-saa-c03-projects.git
cd aws-saa-c03-projects

# تهيئة AWS CLI بحساب Free Tier
aws configure
# AWS Access Key ID: [مفتاحك من IAM Console]
# AWS Secret Access Key: [المفتاح السري]
# Default region name: us-east-1
# Default output format: json

# التحقق من الاتصال
aws sts get-caller-identity
```

### البدء بالترتيب الموصى به

```
P01 → P02 → P05 → P03 → P04
(من الأسهل إلى الأصعب)
```

---

## 📚 متطلبات أساسية

قبل البدء بأي مشروع، يجب أن تعرف:

| المفهوم | المصدر المجاني |
|---------|---------------|
| أساسيات AWS (IAM, VPC, EC2, S3) | [AWS Skill Builder Free](https://skillbuilder.aws/) |
| الشبكات الأساسية (IP, Subnets, DNS) | [AWS Networking Basics](https://aws.amazon.com/getting-started/projects/build-a-vpc/) |
| أساسيات Linux Command Line | [Linux Journey](https://linuxjourney.com/) |
| YAML/JSON للـ CloudFormation | أي مرجع YAML أساسي |

---

## 💰 تقدير التكاليف

> ⚠️ **مهم جداً:** استخدم دائماً **AWS Free Tier Account** للتجربة وأوقف الموارد بعد الانتهاء

| المشروع | التكلفة الشهرية التقديرية | Free Tier مناسب؟ |
|---------|:---:|:---:|
| P01 - Streaming | $150 - $300 | جزئياً ✦ |
| P02 - Banking | ~$0 | ✅ نعم |
| P03 - Data Lake | $200 - $400 | جزئياً ✦ |
| P04 - SaaS + DR | $500+ | ❌ |
| P05 - IoT | $100 - $200 | جزئياً ✦ |

**نصيحة:** ابدأ بـ P02 لأنه مجاني تقريباً، ثم P01 وP05 بتفعيل الموارد وقت التجربة فقط.

---

## 🗺️ خارطة التعلم المقترحة

```
الأسبوع 1-2   ──► أساسيات AWS (IAM + VPC + EC2 + S3)
الأسبوع 3-5   ──► P01: Streaming Platform (CDN + Auto Scaling)
الأسبوع 6-9   ──► P02: Serverless Banking (Lambda + Security)
الأسبوع 10-13 ──► P05: IoT Smart City (IoT Core + Kinesis)
الأسبوع 14-19 ──► P03: Data Lake (Big Data + ML)
الأسبوع 20-27 ──► P04: SaaS + DR (Advanced Multi-Account)
الأسبوع 28    ──► مراجعة + تقديم الامتحان 🎯
```

---

## 📁 هيكل المستودع

```
aws-saa-c03-projects/
│
├── 📄 README.md                          ← أنت هنا
├── 📄 CONTRIBUTING.md
├── 📄 .gitignore
│
├── 📁 project-01-streaming/
│   ├── 📄 README.md                      ← شرح المشروع الكامل
│   ├── 📁 architecture/                  ← ملفات المعمارية (draw.io)
│   ├── 📁 cloudformation/               ← IaC templates
│   │   ├── 01-vpc.yaml
│   │   ├── 02-s3-cloudfront.yaml
│   │   ├── 03-alb-autoscaling.yaml
│   │   └── 04-media-pipeline.yaml
│   ├── 📁 docs/                         ← توثيق مفصل لكل خدمة
│   │   ├── 01-what-is-cloudfront.md
│   │   ├── 02-s3-deep-dive.md
│   │   └── 03-autoscaling-explained.md
│   ├── 📁 scripts/                      ← سكريبتات النشر
│   │   ├── deploy.ps1                   ← Windows PowerShell
│   │   └── cleanup.ps1
│   └── 📁 diagrams/                     ← صور المعمارية
│
├── 📁 project-02-serverless-banking/    ← نفس الهيكل
├── 📁 project-03-data-lake/             ← نفس الهيكل
├── 📁 project-04-saas-multitenant/      ← نفس الهيكل
├── 📁 project-05-iot-smart-city/        ← نفس الهيكل
│
└── 📁 .github/
    └── 📁 ISSUE_TEMPLATE/
        ├── bug_report.md
        └── question.md
```

---

## 🤝 المساهمة

هذا المشروع للتعلم الشخصي. إذا وجدت خطأ أو تريد إضافة تحسين:

1. افتح **Issue** بالقالب المناسب
2. أنشئ **Fork** وعدّل
3. افتح **Pull Request** مع شرح التغيير

---

## 📜 الترخيص

هذا المشروع تحت رخصة **MIT** — استخدمه وشاركه بحرية.

---

<div align="center">

**بُني بـ ❤️ للتحضير لامتحان AWS SAA-C03**

⭐ لا تنسَ تفعيل الـ Star إذا أفادك المشروع!

</div>
