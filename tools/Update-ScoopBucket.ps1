param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [Parameter(Mandatory=$true)]
    [string]$MsiUrl,
    
    [Parameter(Mandatory=$true)]
    [string]$Sha256Hash
)

$ErrorActionPreference = "Stop"

$ScoopBucketRepo = "https://github.com/llyzot/scoop-bucket.git"
$BucketTempDir = New-TemporaryFile | ForEach-Object {
    Remove-Item $_
    New-Item -ItemType Directory -Path $_
}

Write-Host "Cloning scoop-bucket repository to $BucketTempDir..."
git clone $ScoopBucketRepo $BucketTempDir

Push-Location $BucketTempDir

$manifestContent = @{
    version = $Version
    description = "A Unified MCP Server Management App"
    homepage = "https://github.com/mcp-router/mcp-router"
    license = "Sustainable Use License"
    architecture = @{
        "64bit" = @{
            url = $MsiUrl
            hash = "sha256:$Sha256Hash"
        }
    }
    pre_install = 'if (!(Test-Path "$persist_dir")) { New-Item -ItemType Directory -Path "$persist_dir" -Force | Out-Null }'
    installer = @{
        script = @(
            'Start-Process msiexec.exe -ArgumentList @(''/i'', "$file", ''/qn'', ''/norestart'') -Wait'
        )
    }
    uninstaller = @{
        script = @(
            'Start-Process msiexec.exe -ArgumentList @(''/x'', (Get-Item (Get-ItemProperty -Path @(''HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'', ''HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'', ''HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'') | Where-Object { $_.DisplayName -like ''*MCP Router*'' }).UninstallString).Name, ''/qn'', ''/norestart'') -Wait'
        )
    }
    shortcuts = @(
        @("MCP Router.exe", "MCP Router")
    )
} | ConvertTo-Json -Depth 10

Write-Host "Updating mcp-router.json manifest..."
$manifestContent | Out-File -FilePath "bucket/mcp-router.json" -Encoding UTF8

git config user.name "GitHub Actions"
git config user.email "actions@github.com"
git add bucket/mcp-router.json
git commit -m "Update mcp-router manifest to v$Version"

Write-Host "Pushing to scoop-bucket repository..."
git push origin main

Write-Host "✓ Scoop manifest updated successfully"

Pop-Location
Remove-Item -Recurse -Force $BucketTempDir
