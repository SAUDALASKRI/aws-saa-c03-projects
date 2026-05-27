# 📡 Project 05: Smart City IoT Platform — Edge Computing

<div align="center">

<img src="https://img.shields.io/badge/AWS-IoT_Core-3F8624?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Greengrass_V2-3F8624?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Timestream-00B4D8?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/Devices-100K%2B-FF4757?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Latency-Less_than_10ms-00D084?style=for-the-badge"/>

</div>

> 🚧 **This project is under construction** — implement after completing P01 and P02

---

## 🎯 Project Goal

Connect 100,000+ IoT devices (streetlights, cameras, sensors) with:
- **Local edge processing** at less than 10ms latency
- **Cloud analytics** for historical data and trends
- **Instant alerts** when issues are detected

---

## 🗺️ Architecture Overview

```
IoT Devices (sensors/cameras)
         │ MQTT protocol
         ▼
┌──────────────────────┐
│   AWS IoT Core       │  ← Device gateway (mTLS auth)
│   Rules Engine       │
└──────────┬───────────┘
           │
    ┌──────┴──────────────┐
    ▼                     ▼
┌─────────────┐    ┌──────────────────┐
│  Greengrass │    │  Kinesis Data    │
│  (Edge)     │    │  Streams         │
│  < 10ms     │    └────────┬─────────┘
└─────────────┘             │
                   ┌────────┴────────┐
                   ▼                 ▼
             ┌──────────┐    ┌──────────────┐
             │Timestream│    │ Kinesis      │
             │(Time-    │    │ Analytics    │
             │Series DB)│    │ (SQL on      │
             └────┬─────┘    │  stream)     │
                  │          └──────┬───────┘
                  ▼                 ▼
             ┌──────────┐    ┌──────────────┐
             │ Grafana  │    │  IoT Events  │
             │   AMG    │    │  → SNS Alert │
             └──────────┘    └──────────────┘
```

---

## 📚 Services You Will Learn

| Service | Role |
|---------|------|
| **AWS IoT Core** | Device connection gateway |
| **AWS Greengrass V2** | Processing on the device itself |
| **Amazon Kinesis** | Real-time data stream processing |
| **Amazon Timestream** | Time-series database |
| **AWS IoT Events** | Automatic fault detection |
| **Amazon SNS** | Instant alert delivery |
| **Amazon Managed Grafana** | Monitoring dashboards |

---

## 🔑 Key Exam Concepts

**MQTT Protocol:**
```
Primary protocol for IoT — lightweight and perfect for constrained devices
Topic:   city/riyadh/district/olaya/streetlight/001/status
Payload: {"status": "on", "brightness": 80, "power_watts": 45}
```

**IoT Core Rules Engine:**
```
When a message arrives → Rule fires:
  IF topic matches 'city/+/+/+/sensor/+/alert'
  THEN → SNS  → instant alert to operations team
  AND  → DynamoDB → save the record
  AND  → Lambda   → run additional analysis
```

**Edge vs Cloud Processing:**
```
Edge (Greengrass):  Instant decisions < 10ms (emergency shutdowns)
Cloud (IoT Core):   Complex analysis, ML inference, historical reports
```

**Timestream vs DynamoDB for IoT:**
```
DynamoDB:   General purpose, flexible queries
Timestream: Purpose-built for time-series, automatic data aging,
            10x cheaper for time-series workloads
```

---

## 🔜 Implementation Roadmap

```
Week 1: IoT Core setup + device authentication with mTLS certificates
Week 2: Design MQTT topic hierarchy for 100K+ devices
Week 3: Deploy Greengrass V2 on edge devices + custom components
Week 4: Kinesis Data Streams + Kinesis Analytics SQL queries
Week 5: Timestream + Grafana AMG dashboards + IoT Events alerts
```

---

<div align="center">

[⬅️ Project 04](../project-04-saas-multitenant/README.md) | [⬆️ Main README](../README.md)

</div>
