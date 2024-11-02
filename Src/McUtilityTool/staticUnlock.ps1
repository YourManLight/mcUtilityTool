<# 
Not for distribution / Only for educational purpose : YourManLight [YSS Group]
#>

Write-Host "Checking for permissions"
Start-Sleep -Seconds 2
Write-Host "Updating Policy for execution"
Start-Sleep -Seconds 2
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
Write-Host "Policy updated for the current user"
Start-Sleep -Seconds 2

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path $scriptDir
Write-Host "Current directory set to: $(Get-Location)"

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "No admin privileges detected."
    Write-Host "Launching with Admin privileges"
    Start-Sleep -Seconds 1

    Start-Process powershell.exe "-File $($MyInvocation.MyCommand.Path)" -Verb RunAs
    exit
}

$system32Path = "C:\Windows\System32"

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

Write-Host "Taking ownership of the System32 folder..."
Start-Process -FilePath "cmd.exe" -ArgumentList "/c takeown /f `"$system32Path`" /r /d y" -Wait -NoNewWindow
Start-Process -FilePath "cmd.exe" -ArgumentList "/c icacls `"$system32Path`" /grant %USERNAME%:F /t /c /l /q" -Wait -NoNewWindow
Write-Host "Ownership and permissions updated for System32 folder"

Write-Host "Press 1 to start the file operations, 2 to exit."
$choice = Read-Host "Enter your choice"

if ($choice -eq "1") {
    $sourceFile = ".\Windows.ApplicationModel.Store.dll"
    $targetFile = "C:\Windows\System32\Windows.ApplicationModel.Store.dll"

    Write-Host "Deleting old file if it exists..."
    if (Test-Path $targetFile) {
        Remove-Item -Path $targetFile -Force
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
