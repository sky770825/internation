# 快速上傳新工具腳本
# 使用方法: .\upload-tool.ps1 "工具名稱" "提交訊息"

param(
    [Parameter(Mandatory=$true)]
    [string]$ToolName,
    
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage
)

Write-Host "🚀 開始上傳工具: $ToolName" -ForegroundColor Green

# 檢查是否有未提交的更改
$status = git status --porcelain
if ($status) {
    Write-Host "📝 發現未提交的更改，正在提交..." -ForegroundColor Yellow
    
    # 添加所有更改
    git add .
    
    # 提交更改
    git commit -m $CommitMessage
    
    # 推送到 GitHub
    Write-Host "📤 推送到 GitHub..." -ForegroundColor Blue
    git push origin main
    
    Write-Host "✅ 工具上傳完成！" -ForegroundColor Green
    Write-Host "🌐 網址: https://sky770825.github.io/internation/" -ForegroundColor Cyan
} else {
    Write-Host "ℹ️ 沒有發現未提交的更改" -ForegroundColor Blue
}

Write-Host "✨ 腳本執行完成！" -ForegroundColor Green
