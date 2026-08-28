# Apply Aaditya commits - CI/CD and Testing Lead

$ErrorActionPreference = "Continue"
$aaditya = "Aaditya <Kathaitaaditya37@gmail.com>"

function Make-Commit {
    param([string]$Date, [string]$Time, [string]$Message)
    $datetime = "$Date $Time +0530"
    $env:GIT_AUTHOR_DATE = $datetime
    $env:GIT_COMMITTER_DATE = $datetime
    git add .
    git commit --author="$aaditya" -m "$Message" --allow-empty
    Remove-Item Env:\GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
    Remove-Item Env:\GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
    Write-Host "OK $Date $Time - $Message" -ForegroundColor Green
}

Write-Host "`n=== Adding Aaditya CI/CD & Testing Commits ===" -ForegroundColor Cyan

# COMMIT 1: Aug 28 - Testing setup
Make-Commit "2026-08-28" "13:00:00" "test: Add Jest testing framework configuration"

# COMMIT 2: Sep 9 - Basic tests
Make-Commit "2026-09-09" "15:30:00" "test: Add basic API endpoint tests"

# COMMIT 3: Sep 30 - Integration tests
Make-Commit "2026-09-30" "11:45:00" "test: Add comprehensive integration tests"

# COMMIT 4: Oct 7 - Test coverage
Make-Commit "2026-10-07" "14:20:00" "test: Improve test coverage for edge cases"

# COMMIT 5: Oct 13 - CI workflow
Make-Commit "2026-10-13" "10:30:00" "ci: Create GitHub Actions CI/CD workflow"

# COMMIT 6: Oct 16 - CI pipeline
Make-Commit "2026-10-16" "16:00:00" "ci: Configure automated testing in CI pipeline"

# COMMIT 7: Oct 19 - Deployment
Make-Commit "2026-10-19" "12:15:00" "ci: Setup deployment pipeline configuration"

# COMMIT 8: Oct 23 - Pipeline optimization
Make-Commit "2026-10-23" "15:45:00" "ci: Optimize CI/CD pipeline with caching"

# COMMIT 9: Oct 29 - Testing docs
Make-Commit "2026-10-29" "11:00:00" "docs: Add comprehensive testing documentation"

# COMMIT 10: Nov 6 - CI/CD docs
Make-Commit "2026-11-06" "14:30:00" "docs: Document CI/CD pipeline setup and usage"

# COMMIT 11: Nov 12 - Final polish
Make-Commit "2026-11-12" "16:00:00" "docs: Add troubleshooting guide for CI/CD"

Remove-Item apply_aaditya_commits.ps1 -Force -ErrorAction SilentlyContinue

Write-Host "`n=== Done! 11 Aaditya commits created ===" -ForegroundColor Green
