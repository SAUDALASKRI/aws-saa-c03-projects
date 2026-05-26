# 📊 المشروع الثالث: منصة تحليلات بيانات ضخمة — Data Lake

<div align="center">

<img src="https://img.shields.io/badge/AWS-S3_Data_Lake-3F8624?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Glue_ETL-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Athena-8C4FFF?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-SageMaker-00B4D8?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/نطاق_الامتحان-High_Performing-FF9900?style=for-the-badge"/>

</div>

> 🚧 **هذا المشروع قيد الإعداد** — سيُكتمل بعد إتقان P01 وP02

---

## 🎯 هدف المشروع

بناء Data Lake Enterprise-grade لتحليل Petabytes من البيانات مع:
- **Medallion Architecture** (Bronze → Silver → Gold)
- **Real-time Streaming** بـ Kinesis
- **ML Pipeline** بـ SageMaker
- **BI Dashboards** بـ QuickSight

---

## 🗺️ المعمارية المختصرة

```
Data Sources → Kinesis Firehose → S3 Raw (Bronze)
                                       ↓
                              Glue ETL Jobs
                                       ↓
                            S3 Processed (Silver)
                                       ↓
                              Glue ETL Jobs
                                       ↓
                              S3 Curated (Gold)
                               ↙           ↘
                          Athena        Redshift
                            ↓               ↓
                        QuickSight      SageMaker
```

---

## 📚 الخدمات التي ستتعلمها

| الخدمة | الدور | المفهوم الأساسي |
|--------|-------|----------------|
| **Amazon Kinesis** | استيعاب البيانات الآنية | مثل conveyor belt للبيانات |
| **AWS Glue** | ETL (تحويل البيانات) | ينظف ويحول البيانات |
| **Amazon Athena** | استعلامات SQL على S3 | SQL بدون database! |
| **Amazon Redshift** | Data Warehouse | تحليلات ضخمة معقدة |
| **AWS SageMaker** | تدريب نماذج ML | بناء ونشر AI models |
| **Amazon QuickSight** | BI Dashboards | تصويرات بيانية تفاعلية |
| **AWS Lake Formation** | أمان Data Lake | من يرى أي بيانات |

---

## 🔜 خارطة التنفيذ

```
الأسبوع 1: إعداد S3 Medallion Architecture
الأسبوع 2: Kinesis Firehose للـ Real-time Ingestion
الأسبوع 3: Glue Crawlers + ETL Jobs
الأسبوع 4: Athena + Redshift للـ Queries
الأسبوع 5: SageMaker Pipeline
الأسبوع 6: QuickSight Dashboards + Lake Formation
```

---

<div align="center">

[⬅️ المشروع الثاني](../project-02-serverless-banking/README.md) | [⬆️ الرئيسية](../README.md) | [➡️ المشروع الرابع](../project-04-saas-multitenant/README.md)

</div>
