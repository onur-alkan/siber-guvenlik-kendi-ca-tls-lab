$ErrorActionPreference = "Stop"

$repo = "onur-alkan/siber-guvenlik-kendi-ca-tls-lab"
$repoUrl = "https://github.com/$repo.git"

Write-Host "[1/6] GitHub CLI oturumu kontrol ediliyor..." -ForegroundColor Cyan
gh auth status
if ($LASTEXITCODE -ne 0) { throw "GitHub CLI oturumu aktif degil." }

Write-Host "[2/6] Git deposu hazirlaniyor..." -ForegroundColor Cyan
if (-not (Test-Path ".git")) {
    git init
    if ($LASTEXITCODE -ne 0) { throw "git init basarisiz." }
}
git branch -M main

Write-Host "[3/6] Hassas dosya korumasi kontrol ediliyor..." -ForegroundColor Cyan
$mustIgnore = @("01_pki/ca.key", "01_pki/lab.key", "01_pki/lab.csr", "01_pki/ca.srl")
foreach ($f in $mustIgnore) {
    if (Test-Path $f) {
        git check-ignore -q $f
        if ($LASTEXITCODE -ne 0) { throw "Hassas dosya .gitignore tarafindan engellenmiyor: $f" }
    }
}

git add .
$stagedSensitive = git diff --cached --name-only | Where-Object { $_ -match '\.(key|csr|srl)$' }
if ($stagedSensitive) {
    git reset
    throw "Hassas PKI dosyasi stage edildi. Push durduruldu: $($stagedSensitive -join ', ')"
}

$changes = git status --porcelain
if ($changes) {
    git commit -m "Add custom CA TLS laboratory and classroom demo"
    if ($LASTEXITCODE -ne 0) { throw "Commit basarisiz." }
} else {
    Write-Host "Commit edilecek yeni degisiklik yok."
}

Write-Host "[4/6] GitHub reposu kontrol ediliyor..." -ForegroundColor Cyan
gh repo view $repo --json nameWithOwner *> $null
$repoExists = ($LASTEXITCODE -eq 0)

if (-not $repoExists) {
    gh repo create $repo --private --source . --remote origin
    if ($LASTEXITCODE -ne 0) { throw "GitHub reposu olusturulamadi." }
} else {
    $origin = git remote get-url origin 2>$null
    if ($LASTEXITCODE -ne 0) {
        git remote add origin $repoUrl
    } elseif ($origin -ne $repoUrl) {
        git remote set-url origin $repoUrl
    }
}

Write-Host "[5/6] Push..." -ForegroundColor Cyan
git push -u origin main
if ($LASTEXITCODE -ne 0) { throw "Push basarisiz." }

Write-Host "[6/6] Son dogrulama..." -ForegroundColor Cyan
git status
gh repo view $repo --json nameWithOwner,visibility,url

Write-Host ""
Write-Host "Tamamlandi: $repo" -ForegroundColor Green
