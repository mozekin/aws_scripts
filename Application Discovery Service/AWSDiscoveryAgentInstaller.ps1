$ErrorActionPreference = 'stop'

$TMP = $env:temp
$ADSINSTALLER = "$TMP\AWSDiscoveryAgentInstaller.msi"
$AGENTCONF = "C:\ProgramData\AWS\AWS Discovery\config"
$AGENTDL = "https://s3.ap-southeast-2.amazonaws.com/aws-discovery-agent.ap-southeast-2/windows/latest/AWSDiscoveryAgentInstaller.msi"


Write-Host "Downloading AWS Application Discovery Agent MSI installer to $ADSINSTALLER..."
Invoke-WebRequest $AGENTDL -OutFile $ADSINSTALLER

Write-Host "Installing $ADSINSTALLER..."
$ADSINSTALLER = Start-Process msiexec "/i $ADSINSTALLER /quiet" -Wait -PassThru
if ($ADSINSTALLER.ExitCode -gt 0) {
    throw "AWS Application Discovery Agent installer failed with exit code $($ADSINSTALLER.ExitCode)"
    Write-Output 'Refer to C:\ProgramData\AWS\AWS Discovery\Logs for further troubleshooting'
}


# Access keys for AWS Application Discovery Agent activation and configuration
Set-Content -Path $AGENTCONF -Value @"
{
    "agentInventoryURL" : "https://s3.ap-southeast-2.amazonaws.com/aws-discovery-agent.ap-southeast-2/windows/latest/CURRENT_RELEASE_V4",
    "autoUpdate" : true,
    "awsKeyId" : "",
    "awsKeySecret" : "",
    "awsRegion" : "ap-southeast-2",
    "dataCollectionDir" : "",
    "enableAWSSDKLogging" : false,
    "loggingLevel" : "",
    "messageFile" : "",
    "networkFilesRoot" : "",
    "proxyHost" : "",
    "proxyPassword" : "",
    "proxyPort" : 0,
    "proxyScheme" : "",
    "proxyUser" : "",
    "publishCloudWatchConfig" :
    {
        "additionalDimensions" : {},
        "awsRegion" : null,
        "byNic" : false,
        "enabled" : false,
        "metrics" :
        [
            "CPUUtilization",
            "MemoryUtilization",
            "DiskReadBytes",
            "DiskWriteBytes",
            "DiskReadOps",
            "DiskWriteOps",
            "NetworkIn",
            "NetworkOut",
            "NetworkPacketsIn",
            "NetworkPacketsOut"
        ]
    },
    "publisher" : "",
    "serviceProtocol" : "arsenal",
    "useAWSCABundle" : false,
    "verifySSL" : true
}
"@

Write-Host 'Restarting AWS Application Discovery Agent config re-initialisation...'
Restart-Service "AWS Discovery Agent"
Restart-Service "AWS Discovery Updater"
