# 🚀 完全自動化 HTML 上傳系統
# 使用方法: .\auto-upload.ps1 "HTML文件路徑" "工具名稱" "工具描述"

param(
    [Parameter(Mandatory=$true)]
    [string]$HtmlFilePath,
    
    [Parameter(Mandatory=$true)]
    [string]$ToolName,
    
    [Parameter(Mandatory=$true)]
    [string]$ToolDescription,
    
    [Parameter(Mandatory=$false)]
    [string]$Icon = "🛠️"
)

Write-Host "🚀 開始自動化上傳工具: $ToolName" -ForegroundColor Green

# 檢查文件是否存在
if (-not (Test-Path $HtmlFilePath)) {
    Write-Host "❌ 錯誤：找不到文件 $HtmlFilePath" -ForegroundColor Red
    exit 1
}

# 生成安全的文件名
$safeFileName = $ToolName -replace '[^a-zA-Z0-9]', '-' | ForEach-Object { $_.ToLower() }
$safeFileName = "$safeFileName.html"

Write-Host "📁 目標文件名: $safeFileName" -ForegroundColor Blue

# 1. 複製 HTML 文件到項目目錄
Write-Host "📋 步驟 1: 複製 HTML 文件..." -ForegroundColor Yellow
Copy-Item $HtmlFilePath $safeFileName -Force
Write-Host "✅ 文件複製完成" -ForegroundColor Green

# 2. 自動添加返回按鈕到新 HTML 文件
Write-Host "🔗 步驟 2: 添加返回按鈕..." -ForegroundColor Yellow
$htmlContent = Get-Content $safeFileName -Raw -Encoding UTF8

# 檢查是否已經有返回按鈕
if ($htmlContent -notmatch '返回工具集') {
    # 在 <body> 標籤後添加返回按鈕
    $returnButton = @"
  <!-- 返回按鈕 -->
  <a href="index.html" class="back-btn" style="display:inline-flex; align-items:center; gap:6px; padding:8px 12px; background:#ffb703; color:#5b3a29; border-radius:8px; text-decoration:none; font-size:14px; font-weight:600; margin-bottom:16px;">
    <i class="bi bi-arrow-left"></i> 返回工具集
  </a>
  
"@
    
    $htmlContent = $htmlContent -replace '(<body[^>]*>)', "`$1`n$returnButton"
    Set-Content $safeFileName $htmlContent -Encoding UTF8
    Write-Host "✅ 返回按鈕添加完成" -ForegroundColor Green
} else {
    Write-Host "ℹ️ 文件已有返回按鈕" -ForegroundColor Blue
}

# 3. 自動更新導航頁面
Write-Host "📝 步驟 3: 更新導航頁面..." -ForegroundColor Yellow
$indexContent = Get-Content "index.html" -Raw -Encoding UTF8

# 檢查工具是否已經存在
if ($indexContent -match [regex]::Escape($ToolName)) {
    Write-Host "ℹ️ 工具已存在於導航頁面" -ForegroundColor Blue
} else {
    # 在工具列表中添加新工具
    $newToolCard = @"
      <!-- $ToolName -->
      <a href="$safeFileName" class="tool-card">
        <div class="tool-icon">$Icon</div>
        <h2 class="tool-title">$ToolName</h2>
        <p class="tool-desc">$ToolDescription</p>
        <ul class="tool-features">
          <li>功能特色 1</li>
          <li>功能特色 2</li>
          <li>功能特色 3</li>
        </ul>
        <div style="margin-top:16px;">
          <span class="btn">立即使用</span>
        </div>
      </a>
    </div>
"@
    
    # 在 </div> 前插入新工具
    $indexContent = $indexContent -replace '(</div>\s*<!-- 頁尾 -->)', "$newToolCard`n    `$1"
    Set-Content "index.html" $indexContent -Encoding UTF8
    Write-Host "✅ 導航頁面更新完成" -ForegroundColor Green
}

# 4. 自動提交和推送
Write-Host "📤 步驟 4: 上傳到 GitHub..." -ForegroundColor Yellow
git add .
git commit -m "自動添加新工具: $ToolName"
git push origin main

# 5. 顯示結果
Write-Host "`n🎉 自動化上傳完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "📱 工具名稱: $ToolName" -ForegroundColor White
Write-Host "🌐 主頁面: https://sky770825.github.io/internation/" -ForegroundColor Cyan
Write-Host "🔗 工具頁面: https://sky770825.github.io/internation/$safeFileName" -ForegroundColor Cyan
Write-Host "⏱️  部署時間: 通常 1-5 分鐘內完成" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`n✨ 現在您可以訪問上述連結使用新工具了！" -ForegroundColor Green
