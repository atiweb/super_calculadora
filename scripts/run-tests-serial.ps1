$ErrorActionPreference = 'Continue'

Set-StrictMode -Version Latest

Write-Host "Serial test run per file..." -ForegroundColor Yellow

$failed = @()
$testDir = Join-Path $PSScriptRoot '..' | Join-Path -ChildPath 'test'

if (-not (Test-Path $testDir)) {
    Write-Error "Test directory not found: $testDir"
    exit 2
}

$files = Get-ChildItem -Path $testDir -Filter *.dart | Sort-Object Name

foreach ($f in $files) {
    Write-Host "=== Running $($f.Name) ===" -ForegroundColor Cyan
    flutter test -r compact --concurrency=1 $f.FullName
    if ($LASTEXITCODE -ne 0) {
        $failed += $f.Name
    }
}

if ($failed.Count -gt 0) {
    Write-Host "FAILED FILES: $($failed -join ', ')" -ForegroundColor Red
    exit 1
} else {
    Write-Host "All files passed." -ForegroundColor Green
}
