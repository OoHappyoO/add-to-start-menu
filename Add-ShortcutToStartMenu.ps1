param(
    [string] $TargetPath
)

# Basic Validation: If TargetPath is empty, exit
if ([string]::IsNullOrWhiteSpace($TargetPath)) {
    return
}

# Determine what the shortcut name will be
## Default to original filename
### Example TargetPath - C:\foo\fileName.exe
### FileName - fileName
try {
    # Using .NET logic is safer than splitting strings manually
    $FileName = [System.IO.Path]::GetFileNameWithoutExtension($TargetPath)
}
catch {
    # Fallback to manual split if needed
    $FileName = $TargetPath.split('\')[-1].split('.')[0]
}

# Define SavePath for the shortcut
$StartMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
    
# Ensure directory exists
if (-not (Test-Path $StartMenuPath)) { New-Item -ItemType Directory -Path $StartMenuPath | Out-Null }
    
$SavePath = Join-Path -Path $StartMenuPath -ChildPath ($FileName + ".lnk")

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($SavePath)
$Shortcut.TargetPath = $TargetPath
$Shortcut.Save()