# google-services.json をBase64エンコードしてクリップボードにコピーするスクリプト
# GitHub Secretsに貼り付けるために使用

$jsonPath = "android/app/google-services.json"

if (-not (Test-Path $jsonPath)) {
    Write-Host "エラー: $jsonPath が見つかりません" -ForegroundColor Red
    exit 1
}

Write-Host "google-services.json をBase64エンコードしています..." -ForegroundColor Green

try {
    $jsonContent = Get-Content -Path $jsonPath -Raw
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($jsonContent)
    $base64 = [Convert]::ToBase64String($bytes)
    
    # クリップボードにコピー
    $base64 | Set-Clipboard
    
    Write-Host "✓ Base64エンコード完了！" -ForegroundColor Green
    Write-Host "✓ クリップボードにコピーしました" -ForegroundColor Green
    Write-Host ""
    Write-Host "次の手順:" -ForegroundColor Yellow
    Write-Host "1. GitHubリポジトリの Settings → Secrets and variables → Actions に移動"
    Write-Host "2. 'New repository secret' をクリック"
    Write-Host "3. Name: GOOGLE_SERVICES_JSON"
    Write-Host "4. Secret: (Ctrl+Vで貼り付け)"
    Write-Host "5. 'Add secret' をクリック"
    Write-Host ""
    Write-Host "注意: 長い文字列の場合、クリップボードに正しくコピーされないことがあります。"
    Write-Host "その場合は、以下の文字列を手動でコピーしてください:" -ForegroundColor Yellow
    Write-Host $base64
} catch {
    Write-Host "エラー: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

