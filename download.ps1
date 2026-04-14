$ErrorActionPreference = "Stop"

$repo = "Rudyg810/valtorai-releases"
$baseUrl = "https://github.com/$repo/releases/latest/download"

# Detect architecture
$arch = $env:PROCESSOR_ARCHITECTURE
switch ($arch) {
    "AMD64" { $arch = "amd64" }
    "ARM64" { $arch = "arm64" }
    default { throw "Unsupported architecture: $arch" }
}

$asset = "valtor-windows-$arch.zip"
$binaryName = "valtor-windows-$arch.exe"
$url = "$baseUrl/$asset"

$installDir = "$env:LOCALAPPDATA\valtor"
$tempDir = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())

New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

Write-Host "Downloading $asset..."
Invoke-WebRequest -Uri $url -OutFile "$tempDir\$asset"

Write-Host "Extracting..."
Expand-Archive -Path "$tempDir\$asset" -DestinationPath $tempDir -Force

# Find binary
$binPath = Get-ChildItem -Path $tempDir -Recurse -Filter $binaryName | Select-Object -First 1

if (-not $binPath) {
    throw "Binary $binaryName not found in archive"
}

Write-Host "Installing..."
Move-Item $binPath.FullName "$installDir\valtor.exe" -Force

# Add to PATH (user level)
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$userPath;$installDir",
        "User"
    )
}

# Update current session
$env:Path += ";$installDir"

# Unblock binary
Unblock-File "$installDir\valtor.exe"

Write-Host "Running valtor init..."
& "$installDir\valtor.exe" init

Remove-Item -Recurse -Force $tempDir

Write-Host "Installation complete."