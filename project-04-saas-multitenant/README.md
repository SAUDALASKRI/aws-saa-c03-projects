# 🏢 المشروع الرابع: SaaS متعدد المستأجرين + Disaster Recovery

<div align="center">

<img src="https://img.shields.io/badge/AWS-Organizations-E7157B?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-EKS-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/RTO-%3C_15_دقيقة-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/RPO-%3C_5_دقائق-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/نطاق_الامتحان-Resilient_Architectures-0095D5?style=for-the-badge"/>

</div>

> 🚧 **هذا المشروع قيد الإعداد** — الأصعب والأشمل، يُنفَّذ بعد P01 وP02 وP03

---

## 🎯 هدف المشروع

بناء منصة SaaS Enterprise-grade مع:
- **عزل تام** بين العملاء (Multi-Tenant Isolation)
- **RTO < 15 دقيقة** — الاستعادة من الكوارث في أقل من ربع ساعة
- **RPO < 5 دقائق** — لا تفقد أكثر من 5 دقائق من البيانات

---

## 📚 الخدمات التي ستتعلمها

| الخدمة | الدور |
|--------|-------|
| **AWS Organizations** | إدارة حسابات متعددة |
| **Control Tower** | إعداد Landing Zone آمن |
| **Amazon EKS** | Kubernetes مُدار |
| **Aurora Global DB** | قاعدة بيانات عالمية |
| **AWS Backup** | نسخ احتياطي مركزي |
| **Elastic DRS** | استعادة الكوارث السريعة |
| **Transit Gateway** | شبكة بين الـ accounts |

---

## 🔑 المفاهيم الأساسية للامتحان

**DR Strategies (من الأرخص للأسرع):**
```
Backup & Restore  → RTO: ساعات    → RPO: ساعات    → $
Pilot Light       → RTO: 10-30 min → RPO: دقائق   → $$
Warm Standby      → RTO: دقائق    → RPO: ثواني    → $$$
Multi-Site Active → RTO: ثواني    → RPO: ثواني    → $$$$
```

**Multi-Tenant Patterns:**
```
Silo:    حساب AWS منفصل لكل عميل (أكثر عزلاً، أغلى)
Bridge:  VPC منفصل لكل عميل
Pool:    نفس البنية، فصل بالـ Namespace/Schema
```

---

<div align="center">

[⬅️ المشروع الثالث](../project-03-data-lake/README.md) | [⬆️ الرئيسية](../README.md) | [➡️ المشروع الخامس](../project-05-iot-smart-city/README.md)

</div>
