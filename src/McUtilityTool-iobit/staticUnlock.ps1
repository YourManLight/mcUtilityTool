<# 
Not for distribution / Only for educational purpose : YourManLight [YSS Group]
#>

Write-Host "checking for perms"
Start-Sleep -Seconds 0.2
Write-Host "Updating Policy for execution"
Start-Sleep -Seconds 0.2
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
Write-Host "Policy updated for the current user"
Start-Sleep -Seconds 0.2

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path $scriptDir
Write-Host "Current directory set to: $(Get-Location)"


if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "No admin privileges detected."
    Write-Host "Launching with Admin privileges"
    Start-Sleep -Seconds 0.2

    Start-Process powershell.exe "-File $($myInvocation.MyCommand.Path)" -Verb RunAs
    exit
}

$processName = "Minecraft.Windows"
$process = Get-Process -Name $processName -ErrorAction SilentlyContinue

if ($process) {
    Write-Host "Terminating process: $processName (PID: $($process.Id))"
    Stop-Process -Name $processName -Force
    Write-Host "$processName has been terminated."
} else {
    Write-Host "$processName is not running."
}


$sourceFile = ".\Windows.ApplicationModel.Store.dll"
if (!$sourceFile) {
    Write-Host "Windows.ApplicationModel.Store.dll not found in the current directory or its subdirectories."
    Start-Sleep -Seconds 6
    exit
}

$iobitUnlocker = "C:\Program Files (x86)\IObit\IObit Unlocker\IObitUnlocker.exe"
$targetFile = "C:\Windows\System32\Windows.ApplicationModel.Store.dll"

function Logo {
@"
                                                                                                          
_   _  _   _  _      _____  _____  _   __ _____ ______ 
| | | || \ | || |    |  _  |/  __ \| | / /|  ___|| ___ \
| | | ||  \| || |    | | | || /  \/| |/ / | |__  | |_/ /
| | | || . ` || |    | | | || |    |    \ |  __| |    / 
| |_| || |\  || |____\ \_/ /| \__/\| |\  \| |___ | |\ \ 
 \___/ \_| \_/\_____/ \___/  \____/\_| \_/\____/ \_| \_|
                                                        
                                                        
                                             
"@
}

function Done {
@"
______  _____  _   _  _____ 
|  _  \|  _  || \ | ||  ___|
| | | || | | ||  \| || |__  
| | | || | | || . ` ||  __| 
| |/ / \ \_/ /| |\  || |___ 
|___/   \___/ \_| \_/\____/ 
                            
                            
                                      
                                        
"@
}

Clear-Host
Logo
Write-Host ""

Write-Host "Press 1 to start installation, 2 to exit."
$choice = Read-Host "Enter your choice"

if ($choice -eq "1") {
    Write-Host "Checking for IOBit Unlocker..."
    if ((Test-Path $iobitUnlocker)) {
        Write-Host "IObit Unlocker is installed. Continuing..."
    } else {
        Write-Host "IObit Unlocker is not installed. Please install IObit Unlocker and try again."
        Write-Host "https://www.iobit.com/en/iobit-unlocker.php"
        Start-Sleep -Seconds 10
        exit
    }

    Write-Host "Deleting old file if it exists..."
    if (Test-Path $targetFile) {
        Start-Process -FilePath $iobitUnlocker -ArgumentList "/Delete `"$targetFile`"" -Wait
        Write-Host "Deleted old file: $targetFile"
    } else {
        Write-Host "File does not exist: $targetFile"
    }

    Write-Host "Copying new file to FINAL location..."
    Copy-Item -Path $sourceFile -Destination $targetFile -Force
    Write-Host "Copied new file to: $targetFile"

    Write-Host ""
    Done
    Write-Host ""

} elseif ($choice -eq "2") {
    Write-Host "Exiting..."
    exit
} else {
    Write-Host "Invalid choice. Exiting..."
    exit
}

$null = Read-Host "Press Enter to close the program"
