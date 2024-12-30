
function Start-AgentAsInteractiveUser([string]$TaskName, [string]$Execute, [PSCredential]$Credential, [int]$MaxAttemptsCount, [int]$DelayBeforeCheckAgentStatusSeconds) {
    $startTime = [DateTime]::Now
                $userName = $Credential.GetNetworkCredential().UserName
                $userSid = (New-Object System.Security.Principal.NTAccount($userName)).Translate([System.Security.Principal.SecurityIdentifier]).Value
                $cimSession = New-CimSession -ComputerName $env:COMPUTERNAME -Credential $Credential
                $action =  New-ScheduledTaskAction -Execute $Execute -CimSession $cimSession
                $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::FromSeconds(0)) -DontStopOnIdleEnd -MultipleInstances IgnoreNew  -CimSession $cimSession
                $principal = New-ScheduledTaskPrincipal -UserId $userSid -RunLevel Highest -LogonType Interactive -CimSession $cimSession
                Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue -CimSession $cimSession
                Register-ScheduledTask -TaskName $TaskName -Action $action -Principal $principal -Settings $settings -CimSession $cimSession
                $attemptIndex = 1
                while ($attemptIndex -le $MaxAttemptsCount) {
                    Write-Host ""Starting scheduled task with agent, attempt $attemptIndex""
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

$userName = 'runneradmin'
$userPassword = $env:USERNAME + [System.GUID]::NewGuid().ToString().ToUpper()
$userPasswordSecure = ConvertTo-SecureString $userPassword -AsPlainText -Force
Set-LocalUser -Name $userName -Password $userPasswordSecure
$credentials = [System.Management.Automation.PSCredential]::new("$env:COMPUTERNAME\$userName", $userPasswordSecure)

$RegistryPath = 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon'
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value '1' -Type String
Set-ItemProperty $RegistryPath 'ForceAutoLogon' -Value '1' -Type String
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value $userName -type String
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value $userPassword -type String

Set-WSManQuickConfig -Force -SkipNetworkProfileCheck
Start-AgentAsInteractiveUser -TaskName 'Runner' -Execute \"$PWD\\run.cmd\" -Credential $credentials
