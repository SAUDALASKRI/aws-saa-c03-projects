# ============================================================
# setup-github.ps1
# سكريبت إعداد وتحميل المشروع على GitHub (Windows)
# ============================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [string]$RepoName = "aws-saa-c03-projects",
    [string]$YourName = "Your Name",
    [string]$YourEmail = "your@email.com"
)

Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   AWS SAA-C03 Projects — GitHub Setup        ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── الخطوة 1: التحقق من Git ──────────────────────────────
Write-Host "1️⃣  التحقق من تثبيت Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "   ✅ $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Git غير مثبت! قم بتشغيل: winget install Git.Git" -ForegroundColor Red
    exit 1
}

# ── الخطوة 2: إعداد Git ──────────────────────────────────
Write-Host ""
Write-Host "2️⃣  إعداد هوية Git..." -ForegroundColor Yellow
git config --global user.name $YourName
git config --global user.email $YourEmail
git config --global init.defaultBranch main
git config --global core.autocrlf true  # Windows line endings
Write-Host "   ✅ تم إعداد Git بنجاح" -ForegroundColor Green

# ── الخطوة 3: تهيئة المستودع ─────────────────────────────
Write-Host ""
Write-Host "3️⃣  تهيئة Git Repository..." -ForegroundColor Yellow
git init
git add .
git commit -m "🚀 Initial commit: AWS SAA-C03 Projects Structure

- Added 5 complete AWS architecture projects
- Project 01: Streaming Platform (CloudFront + ALB + Auto Scaling)
- Project 02: Serverless Banking (Lambda + DynamoDB + Cognito)
- Project 03: Data Lake (S3 + Glue + Athena + SageMaker)
- Project 04: SaaS Multi-Tenant + DR (EKS + Aurora Global)
- Project 05: IoT Smart City (IoT Core + Greengrass + Timestream)
- Full CloudFormation templates included
- Step-by-step guides for beginners"

Write-Host "   ✅ تم إنشاء أول commit" -ForegroundColor Green

# ── الخطوة 4: إنشاء Repository على GitHub ────────────────
Write-Host ""
Write-Host "4️⃣  الخطوات اليدوية على GitHub:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   أ. افتح: https://github.com/new" -ForegroundColor White
Write-Host "   ب. Repository name: $RepoName" -ForegroundColor White
Write-Host "   ج. Description: مشاريع AWS SAA-C03 - خمسة مشاريع متكاملة" -ForegroundColor White
Write-Host "   د. اختر: Public" -ForegroundColor White
Write-Host "   هـ. لا تضع علامة على README (لدينا واحد بالفعل!)" -ForegroundColor White
Write-Host "   و. اضغط: Create repository" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "   هل أنشأت الـ Repository؟ (اكتب 'y' للمتابعة)"
if ($confirm -ne 'y') {
    Write-Host "   أنشئ الـ repository أولاً ثم أعد تشغيل السكريبت" -ForegroundColor Yellow
    exit 0
}

# ── الخطوة 5: الرفع على GitHub ──────────────────────────
Write-Host ""
Write-Host "5️⃣  رفع الكود على GitHub..." -ForegroundColor Yellow

$remoteUrl = "https://github.com/$GitHubUsername/$RepoName.git"
Write-Host "   URL: $remoteUrl" -ForegroundColor Gray

git remote add origin $remoteUrl
git branch -M main
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║           🎉 تم بنجاح!                       ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "   🔗 مستودعك: https://github.com/$GitHubUsername/$RepoName" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   📌 الخطوات التالية:" -ForegroundColor Yellow
    Write-Host "   1. افتح الرابط وتأكد من ظهور الـ README" -ForegroundColor White
    Write-Host "   2. فعّل GitHub Pages لعرض المشروع" -ForegroundColor White
    Write-Host "   3. ابدأ بتنفيذ Project 01!" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "   ❌ فشل الرفع. تحقق من:" -ForegroundColor Red
    Write-Host "   - هل أنشأت الـ repository على GitHub؟" -ForegroundColor White
    Write-Host "   - هل اسم المستخدم صحيح: $GitHubUsername ؟" -ForegroundColor White
    Write-Host "   - هل اسم الـ Repo صحيح: $RepoName ؟" -ForegroundColor White
}

# ── أوامر مفيدة لاحقاً ───────────────────────────────────
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "أوامر Git التي ستحتاجها باستمرار:" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  # حفظ تعديلاتك ورفعها:" -ForegroundColor DarkGray
Write-Host "  git add ." -ForegroundColor Gray
Write-Host "  git commit -m `"وصف التغيير`"" -ForegroundColor Gray
Write-Host "  git push" -ForegroundColor Gray
Write-Host ""
Write-Host "  # رؤية حالة الملفات:" -ForegroundColor DarkGray
Write-Host "  git status" -ForegroundColor Gray
Write-Host ""
Write-Host "  # رؤية تاريخ الـ commits:" -ForegroundColor DarkGray
Write-Host "  git log --oneline" -ForegroundColor Gray
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
