# Clean up any existing directories
if (Test-Path -Path "extension-package") {
    Remove-Item -Path "extension-package" -Recurse -Force
}

if (Test-Path -Path "public/meetinglingo-extension.zip") {
    Remove-Item -Path "public/meetinglingo-extension.zip" -Force
}

# Create directories
New-Item -ItemType Directory -Path "extension-package" -Force
New-Item -ItemType Directory -Path "extension-package\icons" -Force
New-Item -ItemType Directory -Path "public" -Force

# Copy files with error checking
$files = @(
    @{Source="extension\manifest.json"; Destination="extension-package\manifest.json"},
    @{Source="extension\popup.html"; Destination="extension-package\popup.html"},
    @{Source="extension\popup.js"; Destination="extension-package\popup.js"},
    @{Source="extension\content.js"; Destination="extension-package\content.js"},
    @{Source="extension\background.js"; Destination="extension-package\background.js"},
    @{Source="extension\styles.css"; Destination="extension-package\styles.css"},
    @{Source="extension\icons\icon.svg"; Destination="extension-package\icons\icon.svg"}
)

$allFilesExist = $true
foreach ($file in $files) {
    if (!(Test-Path -Path $file.Source)) {
        Write-Host "Missing file: $($file.Source)" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (!$allFilesExist) {
    Write-Host "Some required files are missing. Please check the files and try again." -ForegroundColor Red
    exit 1
}

# Copy all files
foreach ($file in $files) {
    Copy-Item -Path $file.Source -Destination $file.Destination -Force
}

# Create zip file
Compress-Archive -Path "extension-package\*" -DestinationPath "public/meetinglingo-extension.zip" -Force

# Clean up package directory
Remove-Item -Path "extension-package" -Recurse -Force

Write-Host "Extension packaged successfully as public/meetinglingo-extension.zip" -ForegroundColor Green
Write-Host "Please check that the following files are in the ZIP:"
Write-Host "- manifest.json"
Write-Host "- popup.html"
Write-Host "- popup.js"
Write-Host "- content.js"
Write-Host "- background.js"
Write-Host "- styles.css"
Write-Host "- icons/icon.svg" 