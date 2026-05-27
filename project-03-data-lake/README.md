# 📊 Project 03: Big Data Analytics Platform — Enterprise Data Lake

<div align="center">

<img src="https://img.shields.io/badge/AWS-S3_Data_Lake-3F8624?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Glue_ETL-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Athena-8C4FFF?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-SageMaker-00B4D8?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/Exam_Domain-High_Performing-FF9900?style=for-the-badge"/>

</div>

> 🚧 **This project is under construction** — implement after completing P01 and P02

---

## 🎯 Project Goal

Build an enterprise-grade Data Lake to analyze petabytes of data including:
- **Medallion Architecture** (Bronze → Silver → Gold layers)
- **Real-time streaming** with Kinesis
- **ML pipeline** with SageMaker
- **BI dashboards** with QuickSight

---

## 🗺️ Architecture Overview

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

## 📚 Services You Will Learn

| Service | Role | Core Concept |
|---------|------|-------------|
| **Amazon Kinesis** | Real-time data ingestion | Like a conveyor belt for data |
| **AWS Glue** | ETL (data transformation) | Cleans and transforms data |
| **Amazon Athena** | SQL queries on S3 | SQL without a database server! |
| **Amazon Redshift** | Data Warehouse | Complex large-scale analytics |
| **AWS SageMaker** | Train ML models | Build and deploy AI models |
| **Amazon QuickSight** | BI dashboards | Interactive data visualizations |
| **AWS Lake Formation** | Data Lake security | Who can see which data |

---

## 🔜 Implementation Roadmap

```
Week 1: Set up S3 Medallion Architecture (Bronze/Silver/Gold)
Week 2: Kinesis Data Firehose for real-time ingestion
Week 3: Glue Crawlers + ETL Jobs
Week 4: Athena + Redshift for queries
Week 5: SageMaker ML Pipeline
Week 6: QuickSight Dashboards + Lake Formation permissions
```

---

## 🔑 Key Exam Concepts

**Kinesis Family (for the exam):**
```
Kinesis Data Streams:   Real-time, you control shards, 1-365 day retention
Kinesis Data Firehose:  Managed, auto-scales, loads to S3/Redshift/OpenSearch
Kinesis Data Analytics: Run SQL queries on streaming data in real-time
```

**Glue vs EMR:**
```
AWS Glue:  Serverless ETL, pay per job run, great for straightforward transforms
Amazon EMR: Managed Hadoop/Spark cluster, more control, better for complex ML
```

---

<div align="center">

[⬅️ Project 02](../project-02-serverless-banking/README.md) | [⬆️ Main README](../README.md) | [➡️ Project 04](../project-04-saas-multitenant/README.md)

</div>
