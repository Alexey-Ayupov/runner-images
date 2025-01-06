
function Start-AgentAsInteractiveUser([string]$TaskName, [string]$Execute, [PSCredential]$Credential, [int]$MaxAttemptsCount, [int]$DelayBeforeCheckAgentStatusSeconds) {
    $startTime = [DateTime]::Now
                $userName = $Credential.GetNetworkCredential().UserName
                write-host $userName
                $userSid = (New-Object System.Security.Principal.NTAccount($userName)).Translate([System.Security.Principal.SecurityIdentifier]).Value
                $cimSession = New-CimSession -ComputerName $env:COMPUTERNAME -Credential $Credential
                $action =  New-ScheduledTaskAction -Execute $Execute -CimSession $cimSession
                Write-Host "Registering task with action - $action"
                $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::FromSeconds(0)) -DontStopOnIdleEnd -MultipleInstances IgnoreNew -CimSession $cimSession
                $principal = New-ScheduledTaskPrincipal -UserId $userSid -RunLevel Highest -LogonType Interactive -CimSession $cimSession
                Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue -CimSession $cimSession
                Register-ScheduledTask -TaskName $TaskName -Action $action -Principal $principal -Settings $settings -CimSession $cimSession
                $attemptIndex = 1
                while ($attemptIndex -le $MaxAttemptsCount) {
                    Write-Host "------------in------------"
                    Write-Host "Starting scheduled task with agent, attempt $attemptIndex"
                    & { $ErrorActionPreference = 'Continue'; $out = query user $userName 2>&1; Write-Host $out }
                    Start-ScheduledTask -TaskName $TaskName -CimSession $cimSession
                    Start-Sleep -Seconds $DelayBeforeCheckAgentStatusSeconds
                    if ((Get-ScheduledTask -TaskName $TaskName -CimSession $cimSession).State -eq 'Running') {
                        break
                    }
                    Write-Host 'Failed to start scheduled task with agent, retrying...'
                    $attemptIndex++
                }
                $duration = [DateTime]::Now - $startTime
                Write-Host "Schedule Task state - $((Get-ScheduledTask -TaskName $TaskName -CimSession $cimSession).State)"
                Get-ScheduledTask -TaskName $TaskName -CimSession $cimSession | Get-ScheduledTaskInfo -CimSession $cimSession
                if ((Get-ScheduledTask -TaskName $TaskName -CimSession $cimSession).State -eq 'Running') {
                    Write-Host $((Get-ScheduledTask -TaskName $TaskName -CimSession $cimSession).State)
                    Get-ScheduledTask -TaskName $TaskName -CimSession $cimSession | Get-ScheduledTaskInfo -CimSession $cimSession
                    Write-Host "Scheduled task with agent was started successfully within $($duration.TotalSeconds) seconds with $attemptIndex attempt"
                } else {
                    Write-Host $((Get-ScheduledTask -TaskName $TaskName -CimSession $cimSession).State)
                    Get-ScheduledTask -TaskName $TaskName -CimSession $cimSession | Get-ScheduledTaskInfo -CimSession $cimSession
                    Write-Host "Failed to start scheduled task with agent within $($duration.TotalSeconds) seconds after $attemptIndex attempts"
                    #throw 'Failed to start scheduled task with agent'
                }
                Remove-CimSession -CimSession $cimSession
            }

#$CMDScript='ECHO hello world' | Out-File "${env:IMAGE_FOLDER}\run.cmd"

$userName = $env:RUNNERADMIN_USER
$userPassword = $env:INSTALL_PASSWORD
$userPasswordSecure = ConvertTo-SecureString $userPassword -AsPlainText -Force
$credentials = [System.Management.Automation.PSCredential]::new("$env:COMPUTERNAME\$userName", $userPasswordSecure)

Set-WSManQuickConfig -Force -SkipNetworkProfileCheck
#Start-AgentAsInteractiveUser -TaskName 'Runner' -Execute "${env:IMAGE_FOLDER}\run.cmd" -Credential $credentials -MaxAttemptsCount 2 -DelayBeforeCheckAgentStatusSeconds 10

#$RegistryPath = 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon'
#Get-ItemProperty -Path $RegistryPath

# https://msdn.microsoft.com/en-us/library/system.diagnostics.processstartinfo(v=vs.110).aspx
$processStartInfo = New-Object System.Diagnostics.ProcessStartInfo
$processStartInfo.UserName = $userName
$processStartInfo.Password = (ConvertTo-SecureString $userPassword -AsPlainText -Force)
$processStartInfo.FileName = "cmd"
$processStartInfo.LoadUserProfile = $true
$processStartInfo.UseShellExecute = $false
$processStartInfo.RedirectStandardOutput = $false
$process = [System.Diagnostics.Process]::Start($processStartInfo)
Start-Sleep -Seconds 10
