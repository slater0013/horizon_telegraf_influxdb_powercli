Import-Module -Name VMware.VimAutomation.HorizonView -ErrorAction Stop
Import-Module 'C:\Scripts\VMware.Hv.Helper\VMware.HV.Helper.psm1' -ErrorAction Stop

$username = "administrator@vsphere.local"
$password = ConvertTo-SecureString -AsPlainText -Force "supercalifragilisticexpialidocious"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$horizonserver = "horizon.server.fqdn"
$hvServer = Connect-HVServer -Server $horizonserver -Credential $credentials -ErrorAction Continue
$Global:hvServices = $hvServer.ExtensionData

$pools = Get-HVPoolSummary

foreach($pool in $pools)
{
    $poolstat = $pool.DesktopSummaryData
    $hvpool = Get-HVPool -PoolName $poolstat.Name
    $jsondump = $hvpool | Get-HVPoolSpec -ErrorAction SilentlyContinue | ConvertFrom-Json

    $image_master = $hvpool.AutomatedDesktopData.VirtualCenterNamesData.ParentVmPath
    $snapshot = $jsondump.AutomatedDesktopSpec.virtualCenterProvisioningSettings.VirtualCenterProvisioningData.snapshot
    $oupath = $jsondump.AutomatedDesktopSpec.customizationSettings.AdContainer

    Write-Output "poolinventory,pool=$($poolstat.Name) poolname=`"$($poolstat.Name)`",displayName=`"$($pool.DesktopSummaryData.DisplayName)`",masterimage=`"$($image_master)`",snapshot=`"$($snapshot)`",oupath=`"$($oupath)`""
}


Disconnect-HVServer -Server $horizonserver -Force -Confirm:$false 
