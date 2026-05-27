# 🏦 Project 02: Secure Serverless Banking System

<div align="center">

<img src="https://img.shields.io/badge/AWS-Lambda-FF9900?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/AWS-DynamoDB-3F8624?style=for-the-badge&logo=amazonaws"/>
<img src="https://img.shields.io/badge/Compliance-PCI--DSS-DD344C?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Est._Cost-~$0_Free_Tier-00D084?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Exam_Domain-Secure_Architectures-DD344C?style=for-the-badge"/>

</div>

---

## 🎯 Project Goal

Build a fully serverless financial transaction system including:
- Money transfers between accounts
- Multi-Factor Authentication (MFA)
- Full data encryption
- Tamper-proof audit trail
- PCI-DSS and SOC2 compliance

**Best starting point: nearly zero cost with Free Tier!**

---

## 🗺️ Full Architecture

```
User (Mobile/Web App)
         │
         ▼
┌──────────────────────┐
│  Amazon Cognito      │  ← Login + MFA
│  User Pool           │
└──────────┬───────────┘
           │ JWT Token
           ▼
┌──────────────────────┐
│  API Gateway         │  ← Unified API gateway
│  (REST API)          │
│  + Lambda Authorizer │  ← Validates token
└──────────┬───────────┘
           │
    ┌──────┴──────────────┐
    │                     │
    ▼                     ▼
┌─────────┐         ┌──────────────────┐
│ Lambda  │         │ Step Functions   │  ← Complex transactions
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
                   │    DynamoDB     │  ← Main database
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

SECURITY LAYER (always running in background):
┌─────────────────────────────────────────────┐
│ KMS (Encryption) + GuardDuty (Threat Det.)  │
│ CloudTrail (Logs every API call)            │
│ Macie (Detects sensitive data in S3)        │
│ AWS Config (Monitors configuration drift)   │
└─────────────────────────────────────────────┘
```

---

## 📚 Service Breakdown — From Scratch

### 1️⃣ AWS Lambda — Serverless Compute

**The core concept:**
Instead of buying a server running 24/7, Lambda runs your code **only when needed**.

```
Traditional approach:
  Server running 24 hrs × 30 days = 720 hours
  Even if zero users visited!
  Cost: $50-200/month

With Lambda:
  Runs only when a request arrives
  First 1 million calls/month = completely free! (Free Tier)
  Cost: ~$0
```

**How Lambda works:**
```
1. A trigger arrives (API call, S3 event, timer...)
2. AWS "wakes up" Lambda (Cold Start: ~100ms or Warm: ~5ms)
3. Executes your code
4. Returns the result
5. Shuts down (does NOT stay running!)
```

**Key Lambda limits for the exam:**

| Property | Limit |
|----------|-------|
| Execution timeout | 15 minutes max |
| Memory | 128MB → 10GB |
| Code package size | 50MB (compressed) |
| Concurrent executions | 1,000 (increasable) |
| /tmp storage | 512MB → 10GB |

**Cold Start vs Warm Start:**
```
Cold Start: Lambda doesn't exist → AWS provisions it → runs code
           (200-1000ms delay — problematic for latency-sensitive APIs)

Warm Start: Lambda already in memory → runs immediately
           (5-50ms — fast!)

Solution: Provisioned Concurrency — keeps Lambda "warm" at all times
```

---

### 2️⃣ Amazon API Gateway — API Entry Point

**What is it?**
The single unified entry point for all API requests. Receives HTTP requests and routes them to the appropriate Lambda function.

**Our API structure:**
```
POST /auth/login         → Lambda: AuthHandler
POST /auth/mfa/verify    → Lambda: MFAHandler
GET  /accounts/{id}      → Lambda: GetAccount
POST /transactions       → Lambda: InitiateTransfer
GET  /transactions/{id}  → Lambda: GetTransaction
```

**Key features:**

**1. Lambda Authorizer:**
```
Every API request → API Gateway sends JWT Token → Lambda Authorizer
Lambda Authorizer:
  ✅ Valid token  → allows the request
  ❌ Expired/fake → rejects (403 Forbidden)
```

**2. Request Throttling:**
```
Example configuration:
  Rate:  1,000 requests/second
  Burst: 2,000 requests/second

If 5,000 requests/second arrive:
  First 2,000 → processed
  Remaining   → 429 Too Many Requests
```

**3. Stages:**
```
api.bank.com/dev/transactions     ← Development environment
api.bank.com/staging/transactions ← Testing environment
api.bank.com/prod/transactions    ← Production
```

---

### 3️⃣ Amazon DynamoDB — NoSQL Database

**Why DynamoDB instead of RDS?**

| | DynamoDB | RDS |
|--|---------|-----|
| Type | NoSQL (Key-Value) | SQL (Relational) |
| Scaling | Automatic, unlimited | Manual, limited |
| Performance | < 1ms always | Depends on load |
| Schema | Flexible | Fixed |
| Cost | Pay per use | Pay per server |

**Single-Table Design (most important concept):**

Instead of separate tables, we store everything in one table:

```
Table: BankingApp

PK (Partition Key)    | SK (Sort Key)          | Data
---------------------|------------------------|----------------------------------
USER#u001            | PROFILE                | {name, email, phone, kyc_status}
USER#u001            | ACCOUNT#acc001         | {balance: 5000, currency: SAR}
USER#u001            | ACCOUNT#acc002         | {balance: 200,  currency: USD}
USER#u001            | TXN#2024-01-15#t001    | {amount: 500, type: DEBIT, ...}
USER#u001            | TXN#2024-01-16#t002    | {amount: 1000, type: CREDIT, ...}
ACCOUNT#acc001       | BALANCE                | {current: 5000, available: 4500}
```

**Why this design?**
```
One query fetches all user accounts:
  PK = "USER#u001"  AND  SK begins_with "ACCOUNT"
  Much faster than JOINs across multiple tables!
```

**Global Secondary Index (GSI):**
```
To search by email address:
  GSI: email-index
    PK: email
    SK: userId

Example: "Who owns this email?"
GetItem(GSI: email-index, PK: "user@email.com")
```

**DynamoDB Streams:**
```
Every change in DynamoDB is automatically sent to Lambda:

Transfer recorded in DynamoDB
  → DynamoDB Stream captures the change
  → Lambda sends SMS/Email notification to customer
  → Another Lambda updates Analytics
```

---

### 4️⃣ Amazon Cognito — Identity & Authentication

**What Cognito does:**
- User registration (Sign Up)
- Login (Sign In)
- Multi-Factor Authentication (MFA)
- Email and phone number verification
- Forgot password flow

**Cognito components:**

**User Pool:**
```json
{
  "userId": "user-abc-123",
  "email": "ahmed@gmail.com",
  "phone": "+966501234567",
  "mfaEnabled": true,
  "attributes": {
    "custom:account_type": "premium",
    "custom:kyc_status": "verified"
  }
}
```

**Login flow:**
```
1. User enters Email + Password
2. Cognito verifies credentials
3. ✅ Correct → requests MFA code
4. User enters 6-digit SMS code
5. ✅ Correct → issues JWT Tokens:
   - Access Token  (valid 1 hour)
   - Refresh Token (valid 30 days)
   - ID Token      (user info)
6. Every API call carries Access Token in the Header
```

---

### 5️⃣ AWS KMS — Key Management Service

**The problem:**
Bank data is highly sensitive. It must be encrypted so that even if someone steals a hard drive, they cannot read it.

**Encryption types:**
```
Encryption at Rest (stored data):
  DynamoDB → automatically encrypted with KMS
  S3       → SSE-KMS

Encryption in Transit (data moving):
  HTTPS/TLS → all connections encrypted
```

**KMS Key types:**
```
Customer Managed Key (CMK):
  - You have full control of the key
  - Can disable it immediately (after a security breach)
  - Can define exactly who can use it

AWS Managed Key:
  - AWS manages it
  - Less control, but simpler
```

**Practical example:**
```python
import boto3, base64

kms = boto3.client('kms')

# Encrypt an IBAN before storing
response = kms.encrypt(
    KeyId='arn:aws:kms:us-east-1:123456789:key/abc-123',
    Plaintext='SA1234567890123456789012'
)
encrypted_iban = base64.b64encode(response['CiphertextBlob']).decode()
# Only the encrypted value is stored in DynamoDB

# Decrypt when showing to the user
response = kms.decrypt(CiphertextBlob=base64.b64decode(encrypted_iban))
original_iban = response['Plaintext'].decode()
```

---

### 6️⃣ AWS Step Functions — Workflow Orchestration

**The problem:**
A money transfer requires multiple steps that must ALL succeed or ALL be rolled back:

```
❌ Without Step Functions:
1. Debit from A ✅
2. Credit to B  ❌ (connection failed!)
Result: A lost money, B never received it — catastrophic!

✅ With Step Functions (Saga Pattern):
1. Debit from A
2. Credit to B
3. If any step fails → roll back everything (Compensate)
```

**State Machine for a money transfer:**
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

### 7️⃣ Amazon GuardDuty — AI-Powered Threat Detection

**What it does:**
GuardDuty monitors all activity in your account 24/7 and detects unusual behavior.

**Examples of what it detects:**
```
🚨 Alert 1: UnauthorizedAccess:EC2/TorClient
   EC2 instance connecting to Tor network (suspicious!)

🚨 Alert 2: CryptoCurrency:EC2/BitcoinTool.B
   Server mining cryptocurrency (it's been compromised!)

🚨 Alert 3: UnauthorizedAccess:IAMUser/ConsoleLoginSuccess.B
   Login from a country this user has never logged in from

🚨 Alert 4: Exfiltration:S3/ObjectRead.Unusual
   Unusually large amounts of data being read from S3
```

**How it works:**
```
GuardDuty analyzes:
  ├── CloudTrail Logs (all API calls)
  ├── VPC Flow Logs (all network traffic)
  └── DNS Logs (all DNS queries)

Then compares against:
  ├── AWS Threat Intelligence feeds
  ├── ML behavioral models
  └── Your account's historical patterns
```

---

### 8️⃣ AWS CloudTrail — Immutable Audit Log

**The difference from other logging:**
```
CloudWatch Logs: what is the application doing?
CloudTrail:      who did what in the AWS Console/API?

Example CloudTrail record:
  "On 2024-01-15 at 14:32:05
   User ahmed@company.com (from IP: 1.2.3.4)
   Deleted S3 bucket: customer-data-prod
   Via AWS Console in us-east-1"
```

**Why it matters for banking:**
- **PCI-DSS:** Requires audit trail for every access to cardholder data
- **Legal audit:** "Who accessed customer X's data on day Y?"
- **Digital forensics:** Investigating a security breach

**CloudTrail + Athena = powerful queries:**
```sql
-- Who accessed DynamoDB in the last 24 hours?
SELECT userIdentity.userName, eventTime, eventName, requestParameters
FROM cloudtrail_logs
WHERE eventSource = 'dynamodb.amazonaws.com'
  AND eventTime > current_timestamp - interval '24' hour
ORDER BY eventTime DESC
```

---

## 🛠️ Step-by-Step Implementation

### Phase 1: Cognito Setup

**Step 1: Create User Pool**

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

**Step 2: Create App Client**
```
User Pool → App clients → Create:
  Name: banking-mobile-app
  ✅ ALLOW_USER_PASSWORD_AUTH
  ✅ ALLOW_REFRESH_TOKEN_AUTH
  Access token validity: 1 hour
  Refresh token validity: 30 days
```

---

### Phase 2: DynamoDB

**Step 3: Create the Table**

```powershell
aws dynamodb create-table `
  --table-name BankingApp `
  --billing-mode PAY_PER_REQUEST `
  --attribute-definitions `
      AttributeName=PK,AttributeType=S `
      AttributeName=SK,AttributeType=S `
  --key-schema `
      AttributeName=PK,KeyType=HASH `
      AttributeName=SK,KeyType=RANGE `
  --sse-specification `
      Enabled=true,SSEType=KMS `
  --stream-specification `
      StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES `
  --region us-east-1
```

> 💡 `PAY_PER_REQUEST` = pay only for what you use. Free in Free Tier for first 25GB!

---

### Phase 3: Lambda Functions

**Step 4: Create IAM Role for Lambda**

```powershell
# Create role
aws iam create-role `
  --role-name BankingLambdaRole `
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "lambda.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

# Attach basic permissions
aws iam attach-role-policy `
  --role-name BankingLambdaRole `
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
```

**Step 5: Lambda Code — Check Balance**

```python
# lambda/check_balance/handler.py
import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('BankingApp')

def lambda_handler(event, context):
    """
    Check account balance
    Input:  {userId, accountId}
    Output: {balance, available_balance, currency}
    """
    user_id    = event['userId']
    account_id = event['accountId']

    try:
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
                'accountId':  account_id,
                'balance':    float(account['balance']),
                'available':  float(account['available_balance']),
                'currency':   account['currency']
            })
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal server error'})
        }
```

**Step 6: Deploy Lambda**

```powershell
# Package the code
Compress-Archive -Path handler.py -DestinationPath function.zip

# Create the function
aws lambda create-function `
  --function-name CheckBalance `
  --runtime python3.12 `
  --handler handler.lambda_handler `
  --zip-file fileb://function.zip `
  --role arn:aws:iam::YOUR_ACCOUNT_ID:role/BankingLambdaRole `
  --timeout 30 `
  --memory-size 256 `
  --environment Variables='{TABLE_NAME=BankingApp}'
```

---

### Phase 4: Security

**Step 7: Enable CloudTrail**

```powershell
aws cloudtrail create-trail `
  --name banking-audit-trail `
  --s3-bucket-name banking-cloudtrail-logs `
  --is-multi-region-trail `
  --enable-log-file-validation

aws cloudtrail start-logging --name banking-audit-trail
```

**Step 8: Enable GuardDuty**

```powershell
aws guardduty create-detector `
  --enable `
  --finding-publishing-frequency FIFTEEN_MINUTES

# GuardDuty will start analyzing within minutes!
```

---

## 📊 CloudFormation Template

```yaml
# cloudformation/02-serverless-backend.yaml
AWSTemplateFormatVersion: '2010-09-09'

Resources:
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

  GuardDutyDetector:
    Type: AWS::GuardDuty::Detector
    Properties:
      Enable: true
      FindingPublishingFrequency: FIFTEEN_MINUTES
```

---

## 🧪 Expected SAA-C03 Exam Questions

**Question 1:**
A Lambda function needs to read sensitive data from DynamoDB. What is the best way to grant it permission?

**Answer:** An IAM Role attached to the Lambda function — never put Access Keys in your code!

---

**Question 2:**
A money transfer involves 5 steps. If step 4 fails, what AWS service rolls back the previous steps?

**Answer:** AWS Step Functions with the Saga Pattern + Compensating Transactions.

---

**Question 3:**
A bank needs an audit trail that cannot be deleted even by administrators. How?

**Answer:** CloudTrail → S3 with Object Lock (WORM mode) + Log File Validation enabled.

---

**Question 4:**
Lambda is timing out after 2 seconds on slow requests. How do you improve performance?

**Answer:**
1. Increase memory (CPU scales automatically with RAM in Lambda)
2. Use connection pooling for database
3. Enable Provisioned Concurrency to eliminate cold starts

---

## ✅ Final Checklist

```
Authentication:
□ Cognito User Pool with mandatory MFA
□ Strong password policy enforced
□ Email/phone verification enabled
□ Appropriate JWT token expiry times

API & Logic:
□ API Gateway with Cognito Authorizer
□ Lambda functions with Least Privilege IAM roles
□ Step Functions for complex multi-step transactions
□ SQS Dead Letter Queue for failed messages

Database:
□ DynamoDB with KMS encryption enabled
□ Point-in-Time Recovery (PITR) enabled
□ DynamoDB Streams for event processing
□ Backup policy defined

Security & Compliance:
□ CloudTrail enabled in all regions
□ GuardDuty enabled
□ Macie enabled for S3 sensitive data protection
□ AWS Config Rules for compliance monitoring
□ VPC Endpoints (zero internet traffic for internal services)
□ KMS CMK per data classification
```

---

<div align="center">

[⬅️ Project 01](../project-01-streaming/README.md) | [⬆️ Main README](../README.md) | [➡️ Project 03](../project-03-data-lake/README.md)

</div>
