# 📡 المشروع الخامس: منصة IoT ذكية للمدن — Edge Computing

<div align="center">

<img src="https://img.shields.io/badge/AWS-IoT_Core-3F8624?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Greengrass_V2-3F8624?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-Timestream-00B4D8?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/Devices-100K%2B-FF4757?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Latency-%3C10ms-00D084?style=for-the-badge"/>

</div>

> 🚧 **هذا المشروع قيد الإعداد** — يُنفَّذ بعد P01 وP02

---

## 🎯 هدف المشروع

ربط 100,000+ جهاز IoT (أضواء، كاميرات، حساسات) بـ:
- معالجة **محلية (Edge)** بزمن < 10ms
- **تحليل Cloud** للبيانات التاريخية
- **تنبيهات فورية** عند اكتشاف مشاكل

---

## 📚 الخدمات التي ستتعلمها

| الخدمة | الدور |
|--------|-------|
| **AWS IoT Core** | بوابة اتصال الأجهزة |
| **AWS Greengrass V2** | معالجة على الجهاز نفسه |
| **Amazon Kinesis** | معالجة البيانات الآنية |
| **Amazon Timestream** | قاعدة بيانات Time-Series |
| **AWS IoT Events** | كشف الأعطال تلقائياً |
| **Amazon SNS** | إرسال التنبيهات |
| **Amazon Grafana** | Dashboards المراقبة |

---

## 🔑 مفاهيم IoT للامتحان

**MQTT Protocol:**
```
البروتوكول الرئيسي لـ IoT — خفيف ومناسب للأجهزة المحدودة
Topic: city/riyadh/district/olaya/streetlight/001/status
Payload: {"status": "on", "brightness": 80, "power": 45}
```

**IoT Core Rules:**
```
إذا وصل message → Rule يعمل:
  IF topic = 'city/+/+/+/sensor/+/alert'
  THEN → SNS → رسالة فورية
  AND  → DynamoDB → حفظ السجل
  AND  → Lambda  → تحليل إضافي
```

**Edge vs Cloud Processing:**
```
Edge (Greengrass):  قرارات فورية < 10ms (إيقاف طوارئ)
Cloud (IoT Core):   تحليل معقد، ML، تقارير تاريخية
```

---

<div align="center">

[⬅️ المشروع الرابع](../project-04-saas-multitenant/README.md) | [⬆️ الرئيسية](../README.md)

</div>
