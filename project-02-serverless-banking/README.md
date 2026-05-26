# 🏦 المشروع الثاني: نظام بنكي Serverless آمن ومتوافق

<div align="center">

<img src="https://img.shields.io/badge/AWS-Lambda-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-DynamoDB-3F8624?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/Compliance-PCI--DSS-DD344C?style=for-the-badge"/>
<img src="https://img.shields.io/badge/التكلفة-~$0_Free_Tier-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/نطاق_الامتحان-Secure_Architectures-DD344C?style=for-the-badge"/>

</div>

---

## 🎯 هدف المشروع

بناء نظام معاملات مالية بالكامل **بدون سيرفرات** يشمل:
- تحويل الأموال بين الحسابات
- مصادقة ثنائية العوامل (MFA)
- تشفير كامل للبيانات
- سجل تدقيق لا يمكن التلاعب به
- تطابق PCI-DSS وSOC2

**أفضل نقطة للبدء: التكلفة شبه صفر مع Free Tier!**

---

## 🗺️ المعمارية الكاملة

```
المستخدم (Mobile/Web App)
         │
         ▼
┌──────────────────────┐
│  Amazon Cognito      │  ← تسجيل الدخول + MFA
│  User Pool           │
└──────────┬───────────┘
           │ JWT Token
           ▼
┌──────────────────────┐
│  API Gateway         │  ← بوابة الـ API الموحدة
│  (REST API)          │
│  + Lambda Authorizer │  ← يتحقق من صلاحية الـ Token
└──────────┬───────────┘
           │
    ┌──────┴──────────────┐
    │                     │
    ▼                     ▼
┌─────────┐         ┌──────────────────┐
│ Lambda  │         │ Step Functions   │  ← للمعاملات المعقدة
│ Simple  │         │ (Transfer Money) │
│ Actions │         └────────┬─────────┘
└────┬────┘                  │
     │              ┌────────┴────────┐
     │              ▼                 ▼
     │         Lambda 1          Lambda 2
     │        (Debit Src)      (Credit Dst)
     │              └────────┬────────┘
     │                       ▼
     └──────────►  ┌─────────────────┐
                   │    DynamoDB     │  ← قاعدة البيانات
                   │  (Transactions) │
                   └────────┬────────┘
                            │
                   ┌────────┴────────┐
                   ▼                 ▼
             ┌──────────┐     ┌──────────┐
             │  SQS     │     │ DynamoDB │
             │ (Events) │     │ Streams  │
             └────┬─────┘     └────┬─────┘
                  │                │
                  ▼                ▼
             ┌──────────┐     ┌──────────┐
             │ Lambda   │     │  SNS     │
             │(Notif.)  │     │(Alerts)  │
             └──────────┘     └──────────┘
                   
SECURITY LAYER (يعمل في الخلفية دائماً):
┌─────────────────────────────────────────┐
│ KMS (تشفير) + GuardDuty (كشف تهديدات) │
│ CloudTrail (تسجيل كل API call)          │
│ Macie (كشف بيانات حساسة في S3)          │
│ AWS Config (مراقبة الإعدادات)           │
└─────────────────────────────────────────┘
```

---

## 📚 شرح كل خدمة من الصفر

### 1️⃣ AWS Lambda — الحوسبة بدون سيرفرات

**المفهوم الأساسي:**
بدلاً من شراء سيرفر يعمل 24/7، Lambda يُشغّل الكود **فقط عند الحاجة**.

```
طريقة تقليدية:
  سيرفر يعمل 24 ساعة × 30 يوم = 720 ساعة
  حتى لو لم يأتِ أي مستخدم!
  التكلفة: $50-200/شهر

مع Lambda:
  يُشغَّل فقط عند وجود طلب
  مليون استدعاء/شهر = مجاني تماماً! (Free Tier)
  التكلفة: ~$0
```

**كيف يعمل Lambda:**
```
1. يأتي طلب (API Call, S3 Event, Timer...)
2. AWS "يُصحّي" Lambda (Cold Start: ~100ms أو Warm: ~5ms)
3. ينفذ الكود
4. يُعيد النتيجة
5. ينتهي (لا يبقى شغال!)
```

**حدود Lambda المهمة للامتحان:**

| الخاصية | الحد |
|---------|------|
| وقت التنفيذ | 15 دقيقة كحد أقصى |
| الذاكرة | 128MB → 10GB |
| حجم الكود | 50MB (مضغوط) |
| Concurrent Executions | 1,000 (يمكن زيادتها) |
| /tmp Storage | 512MB → 10GB |

**Cold Start vs Warm Start:**
```
Cold Start: Lambda غير موجود → AWS يُحضّره → يُشغّل الكود
           (200-1000ms تأخير — مشكلة للـ APIs الحساسة للسرعة)

Warm Start: Lambda جاهز في الذاكرة → يُشغّل مباشرة
           (5-50ms — سريع!)

الحل: Provisioned Concurrency — يبقي Lambda "دافئاً" دائماً
```

---

### 2️⃣ Amazon API Gateway — بوابة الـ API

**ما هو؟**
"المدخل" الموحد لكل طلبات API. يستقبل HTTP requests ويوجهها للـ Lambda المناسب.

**بنية الـ API في مشروعنا:**
```
POST /auth/login         → Lambda: AuthHandler
POST /auth/mfa/verify    → Lambda: MFAHandler
GET  /accounts/{id}      → Lambda: GetAccount
POST /transactions       → Lambda: InitiateTransfer
GET  /transactions/{id}  → Lambda: GetTransaction
```

**ميزات مهمة:**

**1. Lambda Authorizer:**
```
كل طلب API → API Gateway يرسل الـ JWT Token → Lambda Authorizer
Lambda Authorizer:
  ✅ Token صالح → يسمح بالطلب
  ❌ Token منتهي/مزوّر → يرفض (403 Forbidden)
```

**2. Request Throttling:**
```
إعداد مثال:
  Rate: 1000 requests/second
  Burst: 2000 requests/second

لو جاءت 5000 طلب/ثانية:
  أول 2000 → تُعالج
  الباقي → 429 Too Many Requests
```

**3. مراحل (Stages):**
```
api.bank.com/dev/transactions    ← بيئة تطوير
api.bank.com/staging/transactions ← بيئة اختبار
api.bank.com/prod/transactions   ← الإنتاج
```

---

### 3️⃣ Amazon DynamoDB — قاعدة البيانات NoSQL

**لماذا DynamoDB وليس RDS؟**

| | DynamoDB | RDS |
|--|---------|-----|
| النوع | NoSQL (Key-Value) | SQL (Relational) |
| الـ Scaling | تلقائي لا نهائي | يدوي، محدود |
| الأداء | < 1ms دائماً | يعتمد على الحجم |
| الـ Schema | مرن | ثابت |
| التكلفة | ادفع للاستخدام | ادفع للسيرفر |

**Single-Table Design (الأهم):**

بدلاً من جداول منفصلة، نضع كل البيانات في جدول واحد:

```
Table: BankingApp

PK (Partition Key)    | SK (Sort Key)        | Data
---------------------|---------------------|----------------------------------
USER#u001            | PROFILE             | {name, email, phone, kyc_status}
USER#u001            | ACCOUNT#acc001      | {balance: 5000, currency: SAR}
USER#u001            | ACCOUNT#acc002      | {balance: 200, currency: USD}
USER#u001            | TXN#2024-01-15#t001 | {amount: 500, type: DEBIT, ...}
USER#u001            | TXN#2024-01-16#t002 | {amount: 1000, type: CREDIT, ...}
ACCOUNT#acc001       | BALANCE             | {current: 5000, available: 4500}
```

**فائدة هذا الديزاين:**
```sql
-- استعلام واحد يجلب كل بيانات المستخدم:
PK = "USER#u001"  AND  SK begins_with "ACCOUNT"
-- أسرع بكثير من JOIN بين جداول!
```

**Global Secondary Index (GSI):**
```
إذا أردت البحث بـ Email:
  GSI: email-index
    PK: email
    SK: userId
    
مثال: "من يملك هذا الـ email؟"
GetItem(GSI: email-index, PK: "user@email.com")
```

**DynamoDB Streams:**
```
كل تغيير في DynamoDB يُرسَل لـ Lambda تلقائياً:

تحويل مالي يُسجَّل في DynamoDB
  → DynamoDB Stream يلتقط التغيير
  → Lambda يُرسل إشعار SMS/Email للعميل
  → Lambda آخر يُحدّث الـ Analytics
```

---

### 4️⃣ Amazon Cognito — إدارة الهوية والمصادقة

**ما يفعله Cognito:**
- تسجيل المستخدمين (Sign Up)
- تسجيل الدخول (Sign In)
- المصادقة الثنائية (MFA)
- التحقق من البريد الإلكتروني ورقم الهاتف
- نسيت كلمة المرور

**مكونات Cognito:**

**User Pool:**
```
قاعدة بيانات المستخدمين:
{
  userId: "user-abc-123",
  email: "ahmed@gmail.com",
  phone: "+966501234567",
  mfaEnabled: true,
  attributes: {
    custom:account_type: "premium",
    custom:kyc_status: "verified"
  }
}
```

**تدفق تسجيل الدخول:**
```
1. المستخدم يُدخل Email + Password
2. Cognito يتحقق
3. ✅ صحيح → يطلب رمز MFA
4. مستخدم يُدخل رمز SMS (6 أرقام)
5. ✅ صحيح → يُعطي JWT Tokens:
   - Access Token  (صالح 1 ساعة)
   - Refresh Token (صالح 30 يوم)
   - ID Token (معلومات المستخدم)
6. كل API call يحمل Access Token في الـ Header
```

**JWT Token مثال:**
```json
{
  "sub": "user-abc-123",
  "email": "ahmed@gmail.com",
  "cognito:groups": ["premium-users"],
  "exp": 1735689600,
  "iat": 1735686000
}
```
*(هذا مُشفَّر بـ Base64 ويمكن لـ Lambda Authorizer فك تشفيره)*

---

### 5️⃣ AWS KMS — خدمة إدارة المفاتيح

**المشكلة:**
بيانات البنك حساسة. يجب تشفيرها حتى لو سرق أحد الـ Hard Drive لن يقدر يقرأها.

**أنواع التشفير:**
```
Encryption at Rest (بيانات ساكنة):
  DynamoDB → مشفر تلقائياً بـ KMS
  S3 → SSE-KMS
  
Encryption in Transit (بيانات تتنقل):
  HTTPS/TLS → كل الاتصالات مشفرة
```

**KMS Keys:**
```
Customer Managed Key (CMK):
  - أنت تتحكم في الـ Key بالكامل
  - تقدر تُعطّله فوراً (إذا حدث خرق أمني)
  - تقدر تضبط من يستطيع استخدامه

AWS Managed Key:
  - AWS يديره
  - أقل تحكماً لكن أسهل
```

**مثال عملي:**
```python
# تشفير رقم حساب بنكي قبل تخزينه
import boto3, base64

kms = boto3.client('kms')

# تشفير
response = kms.encrypt(
    KeyId='arn:aws:kms:us-east-1:123456789:key/abc-123',
    Plaintext='SA1234567890123456789012'  # رقم IBAN
)
encrypted_iban = base64.b64encode(response['CiphertextBlob']).decode()
# يُخزَّن المشفَّر فقط في DynamoDB

# فك التشفير (عند عرضه للمستخدم)
response = kms.decrypt(CiphertextBlob=base64.b64decode(encrypted_iban))
original_iban = response['Plaintext'].decode()
```

---

### 6️⃣ AWS Step Functions — تنسيق العمليات المعقدة

**المشكلة:**
تحويل المال يتطلب خطوات متعددة يجب أن تنجح كلها أو تُلغى كلها:

```
❌ بدون Step Functions:
1. اخصم من A ✅
2. أضف لـ B ❌ (فشل الاتصال!)
نتيجة: A خسر المال، B لم يستلم — كارثة!

✅ مع Step Functions (Saga Pattern):
1. اخصم من A
2. أضف لـ B
3. إذا فشل أي خطوة → تراجع عن كل شيء (Compensate)
```

**State Machine لتحويل مالي:**
```json
{
  "StartAt": "ValidateTransfer",
  "States": {
    "ValidateTransfer": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:ValidateLambda",
      "Next": "CheckBalance",
      "Catch": [{"ErrorEquals": ["InvalidTransfer"], "Next": "FailState"}]
    },
    "CheckBalance": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:CheckBalanceLambda",
      "Next": "DebitSource",
      "Catch": [{"ErrorEquals": ["InsufficientFunds"], "Next": "FailState"}]
    },
    "DebitSource": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:DebitLambda",
      "Next": "CreditDestination"
    },
    "CreditDestination": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:CreditLambda",
      "Next": "SendNotification"
    },
    "SendNotification": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:NotifyLambda",
      "End": true
    },
    "FailState": {
      "Type": "Fail",
      "Error": "TransferFailed"
    }
  }
}
```

---

### 7️⃣ Amazon GuardDuty — كشف التهديدات بالذكاء الاصطناعي

**ما يفعله:**
GuardDuty يراقب كل نشاط في حسابك 24/7 ويكشف السلوك الغريب.

**أمثلة على ما يكتشفه:**
```
🚨 تنبيه 1: UnauthorizedAccess:EC2/TorClient
   EC2 instance يتصل بشبكة Tor (مشبوه!)

🚨 تنبيه 2: CryptoCurrency:EC2/BitcoinTool.B
   Server يُعدِّن عملات رقمية (تم اختراقه!)

🚨 تنبيه 3: UnauthorizedAccess:IAMUser/ConsoleLoginSuccess.B
   تسجيل دخول من دولة لم يسجل منها هذا المستخدم قط

🚨 تنبيه 4: Exfiltration:S3/ObjectRead.Unusual
   قراءة كميات ضخمة غير مألوفة من S3
```

**كيف يعمل:**
```
GuardDuty يحلل:
  ├── CloudTrail Logs (كل API calls)
  ├── VPC Flow Logs (كل حركة الشبكة)
  └── DNS Logs (كل استعلامات DNS)
  
ثم يقارن بـ:
  ├── AWS Threat Intelligence
  ├── ML models
  └── الأنماط التاريخية لحسابك
```

---

### 8️⃣ AWS CloudTrail — سجل كل شيء

**الفرق بين CloudTrail وغيره:**
```
CloudWatch Logs: ماذا يفعل التطبيق
CloudTrail:      من فعل ماذا في AWS Console/API

مثال:
  CloudTrail يسجل:
  "في 2024-01-15 الساعة 14:32:05
   المستخدم ahmed@company.com (من IP: 1.2.3.4)
   حذف S3 bucket: customer-data-prod
   من AWS Console في us-east-1"
```

**لماذا مهم للبنك؟**
- **PCI-DSS:** يتطلب audit trail لكل وصول لبيانات الكارت
- **المراجعة القانونية:** "من وصل لبيانات العميل X يوم Y؟"
- **الجنائيات الرقمية:** تحقيق في اختراق أمني

**CloudTrail + Athena = قوة:**
```sql
-- من وصل لـ DynamoDB في آخر 24 ساعة؟
SELECT userIdentity.userName, eventTime, eventName, requestParameters
FROM cloudtrail_logs
WHERE eventSource = 'dynamodb.amazonaws.com'
  AND eventTime > current_timestamp - interval '24' hour
ORDER BY eventTime DESC
```

---

## 🛠️ خطوات التنفيذ التفصيلية

### المرحلة الأولى: إعداد Cognito

**الخطوة 1: إنشاء User Pool**

```
Cognito → User Pools → Create:

Pool Name: banking-users

Sign-in options:
  ✅ Email
  ✅ Phone number

Password policy:
  Minimum length: 12
  ✅ Uppercase
  ✅ Lowercase  
  ✅ Numbers
  ✅ Special characters

MFA:
  ✅ Required for all users
  Options: SMS + TOTP (Google Authenticator)

User verification:
  ✅ Email verification required
```

**الخطوة 2: إنشاء App Client**
```
User Pool → App clients → Create:
  Name: banking-mobile-app
  ✅ ALLOW_USER_PASSWORD_AUTH
  ✅ ALLOW_REFRESH_TOKEN_AUTH
  Access token validity: 1 hour
  Refresh token validity: 30 days
```

---

### المرحلة الثانية: DynamoDB

**الخطوة 3: إنشاء الجدول**

```bash
aws dynamodb create-table \
  --table-name BankingApp \
  --billing-mode PAY_PER_REQUEST \
  --attribute-definitions \
      AttributeName=PK,AttributeType=S \
      AttributeName=SK,AttributeType=S \
      AttributeName=GSI1PK,AttributeType=S \
      AttributeName=GSI1SK,AttributeType=S \
  --key-schema \
      AttributeName=PK,KeyType=HASH \
      AttributeName=SK,KeyType=RANGE \
  --global-secondary-indexes \
      '[{
        "IndexName": "GSI1",
        "Keys": [
          {"AttributeName":"GSI1PK","KeyType":"HASH"},
          {"AttributeName":"GSI1SK","KeyType":"RANGE"}
        ],
        "Projection": {"ProjectionType":"ALL"}
      }]' \
  --sse-specification \
      Enabled=true,SSEType=KMS \
  --stream-specification \
      StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES \
  --region us-east-1
```

> 💡 `PAY_PER_REQUEST` = ادفع فقط على الاستخدام. مجاني في Free Tier لأول 25GB!

---

### المرحلة الثالثة: Lambda Functions

**الخطوة 4: إنشاء IAM Role للـ Lambda**

```bash
# إنشاء Role
aws iam create-role \
  --role-name BankingLambdaRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "lambda.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

# إضافة صلاحيات
aws iam attach-role-policy \
  --role-name BankingLambdaRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# صلاحية DynamoDB (Least Privilege!)
aws iam put-role-policy \
  --role-name BankingLambdaRole \
  --policy-name DynamoDBAccess \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:Query"
      ],
      "Resource": "arn:aws:dynamodb:us-east-1:*:table/BankingApp*"
    }]
  }'
```

**الخطوة 5: كود Lambda — التحقق من الرصيد**

```python
# lambda/check_balance/handler.py
import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('BankingApp')

def lambda_handler(event, context):
    """
    التحقق من رصيد الحساب
    Input: {userId, accountId}
    Output: {balance, available_balance, currency}
    """
    
    user_id = event['userId']
    account_id = event['accountId']
    
    try:
        # جلب بيانات الحساب
        response = table.get_item(
            Key={
                'PK': f'USER#{user_id}',
                'SK': f'ACCOUNT#{account_id}'
            }
        )
        
        if 'Item' not in response:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Account not found'})
            }
        
        account = response['Item']
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'accountId': account_id,
                'balance': float(account['balance']),
                'available': float(account['available_balance']),
                'currency': account['currency']
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal server error'})
        }
```

**الخطوة 6: نشر Lambda**

```bash
# ضغط الكود
cd lambda/check_balance
Compress-Archive -Path handler.py -DestinationPath function.zip

# رفع الدالة
aws lambda create-function \
  --function-name CheckBalance \
  --runtime python3.12 \
  --handler handler.lambda_handler \
  --zip-file fileb://function.zip \
  --role arn:aws:iam::YOUR_ACCOUNT_ID:role/BankingLambdaRole \
  --timeout 30 \
  --memory-size 256 \
  --environment Variables='{TABLE_NAME=BankingApp}'
```

---

### المرحلة الرابعة: API Gateway

**الخطوة 7: إنشاء REST API**

```bash
# إنشاء API
aws apigateway create-rest-api \
  --name banking-api \
  --endpoint-configuration types=REGIONAL

# إنشاء Resource
aws apigateway create-resource \
  --rest-api-id YOUR_API_ID \
  --parent-id ROOT_RESOURCE_ID \
  --path-part accounts

# إضافة Method GET
aws apigateway put-method \
  --rest-api-id YOUR_API_ID \
  --resource-id RESOURCE_ID \
  --http-method GET \
  --authorization-type COGNITO_USER_POOLS \
  --authorizer-id YOUR_AUTHORIZER_ID
```

---

### المرحلة الخامسة: الأمان

**الخطوة 8: تفعيل CloudTrail**

```bash
aws cloudtrail create-trail \
  --name banking-audit-trail \
  --s3-bucket-name banking-cloudtrail-logs \
  --is-multi-region-trail \
  --enable-log-file-validation  # ← يضمن عدم التلاعب بالـ logs

aws cloudtrail start-logging --name banking-audit-trail
```

**الخطوة 9: تفعيل GuardDuty**

```bash
aws guardduty create-detector \
  --enable \
  --finding-publishing-frequency FIFTEEN_MINUTES

# سيبدأ GuardDuty بالتحليل خلال دقائق!
```

---

## 📊 CloudFormation — النشر الكامل تلقائياً

```yaml
# cloudformation/02-serverless-backend.yaml
AWSTemplateFormatVersion: '2010-09-09'

Resources:
  # DynamoDB Table
  BankingTable:
    Type: AWS::DynamoDB::Table
    Properties:
      TableName: BankingApp
      BillingMode: PAY_PER_REQUEST
      AttributeDefinitions:
        - AttributeName: PK
          AttributeType: S
        - AttributeName: SK
          AttributeType: S
      KeySchema:
        - AttributeName: PK
          KeyType: HASH
        - AttributeName: SK
          KeyType: RANGE
      SSESpecification:
        SSEEnabled: true
        SSEType: KMS
      StreamSpecification:
        StreamViewType: NEW_AND_OLD_IMAGES
      PointInTimeRecoverySpecification:
        PointInTimeRecoveryEnabled: true
      Tags:
        - Key: Project
          Value: BankingApp

  # Lambda Execution Role
  LambdaExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: BankingLambdaRole
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
      Policies:
        - PolicyName: DynamoDBAccess
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - dynamodb:GetItem
                  - dynamodb:PutItem
                  - dynamodb:UpdateItem
                  - dynamodb:Query
                  - dynamodb:TransactWriteItems
                Resource: !GetAtt BankingTable.Arn

  # Cognito User Pool
  UserPool:
    Type: AWS::Cognito::UserPool
    Properties:
      UserPoolName: banking-users
      MfaConfiguration: 'ON'
      EnabledMfas:
        - SMS_MFA
        - SOFTWARE_TOKEN_MFA
      PasswordPolicy:
        MinimumLength: 12
        RequireUppercase: true
        RequireLowercase: true
        RequireNumbers: true
        RequireSymbols: true
      AutoVerifiedAttributes:
        - email

  # GuardDuty
  GuardDutyDetector:
    Type: AWS::GuardDuty::Detector
    Properties:
      Enable: true
      FindingPublishingFrequency: FIFTEEN_MINUTES

Outputs:
  TableName:
    Value: !Ref BankingTable
    Export:
      Name: BankingTableName

  UserPoolId:
    Value: !Ref UserPool
    Export:
      Name: BankingUserPoolId
```

---

## 🧪 أسئلة امتحان SAA-C03

**❓ السؤال 1:**
تطبيق Lambda يحتاج قراءة بيانات حساسة من DynamoDB. ما أفضل طريقة لمنحه الصلاحية؟

**✅ الجواب:** IAM Role مرتبط بالـ Lambda — لا تضع Access Keys في الكود أبداً!

---

**❓ السؤال 2:**
تحويل مالي يتضمن 5 خطوات. إذا فشلت الخطوة 4، ما الأداة التي تتراجع عن الخطوات السابقة؟

**✅ الجواب:** AWS Step Functions مع Saga Pattern + Compensating Transactions

---

**❓ السؤال 3:**
البنك يحتاج audit trail لا يمكن حذفه حتى من المديرين. كيف؟

**✅ الجواب:** CloudTrail → S3 مع Object Lock (WORM) + Log File Validation

---

**❓ السؤال 4:**
Lambda تُعالج طلبات بطيئة (timeout بعد 2 ثانية). كيف تحسن الأداء؟

**✅ الجواب:**
1. زيادة الذاكرة (CPU يزيد تلقائياً مع RAM)
2. Connection Pooling للـ Database
3. Provisioned Concurrency لإزالة Cold Starts

---

## ✅ قائمة التحقق النهائية

```
Authentication:
□ Cognito User Pool مع MFA إجباري
□ Password Policy صارم
□ Email/Phone verification
□ JWT Token expiry مناسب

API & Logic:
□ API Gateway مع Cognito Authorizer
□ Lambda Functions بـ Least Privilege IAM
□ Step Functions للمعاملات المعقدة
□ SQS Dead Letter Queue للـ failures

Database:
□ DynamoDB مع KMS encryption
□ Point-in-Time Recovery مفعّل
□ DynamoDB Streams للـ event processing
□ Backup policy محدد

Security & Compliance:
□ CloudTrail في كل الـ regions
□ GuardDuty مفعّل
□ Macie لحماية البيانات الحساسة في S3
□ AWS Config Rules للـ compliance
□ VPC Endpoints (لا traffic عبر الإنترنت)
□ KMS CMK لكل نوع بيانات
```

---

<div align="center">

[⬅️ المشروع الأول](../project-01-streaming/README.md) | [⬆️ الرئيسية](../README.md) | [➡️ المشروع الثالث](../project-03-data-lake/README.md)

</div>
