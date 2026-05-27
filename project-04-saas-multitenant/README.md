# 🏢 Project 04: Multi-Tenant SaaS Platform + Disaster Recovery

<div align="center">

<img src="https://img.shields.io/badge/AWS-Organizations-E7157B?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-EKS-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/RTO-Less_than_15_min-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/RPO-Less_than_5_min-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Exam_Domain-Resilient_Architectures-0095D5?style=for-the-badge"/>

</div>

> 🚧 **This project is under construction** — the most advanced project, implement after P01, P02, and P03

---

## 🎯 Project Goal

Build an enterprise-grade SaaS platform with:
- **Full tenant isolation** (Multi-Tenant Architecture)
- **RTO < 15 minutes** — recover from disaster in under 15 minutes
- **RPO < 5 minutes** — lose no more than 5 minutes of data

---

## 📚 Services You Will Learn

| Service | Role |
|---------|------|
| **AWS Organizations** | Manage multiple AWS accounts |
| **Control Tower** | Set up a secure Landing Zone |
| **Amazon EKS** | Managed Kubernetes |
| **Aurora Global DB** | Multi-region database |
| **AWS Backup** | Centralized backup management |
| **Elastic DRS** | Fast disaster recovery |
| **Transit Gateway** | Cross-account networking |

---

## 🔑 Key Exam Concepts

**DR Strategies (cheapest to fastest recovery):**
```
Backup & Restore  → RTO: Hours     → RPO: Hours    → $
Pilot Light       → RTO: 10-30 min → RPO: Minutes  → $$
Warm Standby      → RTO: Minutes   → RPO: Seconds  → $$$
Multi-Site Active → RTO: Seconds   → RPO: Seconds  → $$$$
```

**Multi-Tenant Isolation Patterns:**
```
Silo:   Separate AWS account per customer (most isolated, most expensive)
Bridge: Separate VPC per customer
Pool:   Shared infrastructure, isolated by Namespace/Schema
```

**RTO vs RPO (must know for exam):**
```
RTO (Recovery Time Objective):
  How LONG can the system be down?
  "We must be back online within 15 minutes"

RPO (Recovery Point Objective):
  How much DATA can we afford to lose?
  "We cannot lose more than 5 minutes of transactions"
```

---

## 🔜 Implementation Roadmap

```
Week 1-2: AWS Organizations + Control Tower Landing Zone
Week 3-4: Transit Gateway + VPC Peering across accounts
Week 5-6: EKS cluster + Karpenter for node provisioning
Week 7:   Aurora Global Cluster (Primary + DR region)
Week 8:   AWS Backup + DRS configuration + DR testing
```

---

<div align="center">

[⬅️ Project 03](../project-03-data-lake/README.md) | [⬆️ Main README](../README.md) | [➡️ Project 05](../project-05-iot-smart-city/README.md)

</div>
