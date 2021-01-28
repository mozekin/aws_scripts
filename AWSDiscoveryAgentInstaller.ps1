$TMP = $env:temp
$ADSINSTALLER = "$TMP\AWSDiscoveryAgentInstaller.msi"
$AGENTCONF = "C:\ProgramData\AWS\AWS Discovery\config"
$AGENTDL = "https://s3.ap-southeast-2.amazonaws.com/aws-discovery-agent.ap-southeast-2/windows/latest/AWSDiscoveryAgentInstaller.msi"


Write-Host "Downloading Signal Sciences MSI installer to $ADSINSTALLER..."
Invoke-WebRequest $AGENTDL -OutFile $ADSINSTALLER

Write-Host "Installing $ADSINSTALLER..."
$ADSINSTALLER = Start-Process msiexec "/i $ADSINSTALLER /quiet" -Wait -PassThru
if ($ADSINSTALLER.ExitCode -gt 0) {
    throw "AWS Application Discovery Agent installer failed with exit code $($ADSINSTALLER.ExitCode)"
    Write-Output 'Refer to C:\ProgramData\AWS\AWS Discovery\Logs for further troubleshooting'
}


# Access keys for AWS Application Discovery Agent activation and configuration
Set-Content -Path $AGENTCONF -Value @"
REGION=ap-southeast-2
KEY_ID="REDACTED"
KEY_SECRET="REDACTED"

"@

Write-Host 'Restarting AWS Application Discovery Agent agent config re-initialisation...'
Restart-Service "AWS Discovery Agent"
Restart-Service "AWS Discovery Updater"
