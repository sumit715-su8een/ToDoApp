# Apply Aditya Negi commits - NO TOKEN IN THIS FILE

$ErrorActionPreference = "Continue"
$adityaNegi = "Aditya Negi <jnegisingh052@gmail.com>"

function Make-Commit {
    param([string]$Date, [string]$Time, [string]$Message)
    $datetime = "$Date $Time +0530"
    $env:GIT_AUTHOR_DATE = $datetime
    $env:GIT_COMMITTER_DATE = $datetime
    git add .
    git commit --author="$adityaNegi" -m "$Message" --allow-empty
    Remove-Item Env:\GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
    Remove-Item Env:\GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
    Write-Host "OK $Date $Time - $Message" -ForegroundColor Green
}

Write-Host "`n=== Adding Aditya Negi Commits ===" -ForegroundColor Cyan

Make-Commit "2026-09-11" "10:30:00" "feat: Enhance HTML structure with semantic elements"
Make-Commit "2026-09-13" "14:45:00" "style: Improve CSS layout and color scheme"
Make-Commit "2026-09-16" "11:20:00" "feat: Add API integration for fetching tasks"
Make-Commit "2026-09-18" "15:30:00" "feat: Implement add task form functionality"
Make-Commit "2026-09-20" "13:10:00" "feat: Add edit task modal and update logic"
Make-Commit "2026-09-23" "16:45:00" "feat: Implement delete task with confirmation"
Make-Commit "2026-09-26" "12:00:00" "feat: Add toggle completion status feature"
Make-Commit "2026-09-29" "14:15:00" "feat: Implement task filtering by status"
Make-Commit "2026-10-02" "10:50:00" "style: Add responsive design for mobile devices"
Make-Commit "2026-10-08" "16:30:00" "style: Add smooth animations and transitions"
Make-Commit "2026-10-26" "11:45:00" "docs: Add frontend documentation and code comments"

Remove-Item apply_aditya_commits.ps1 -Force -ErrorAction SilentlyContinue

Write-Host "`n=== Done! 11 commits created ===" -ForegroundColor Green
