Import-Module -Name VMware.VimAutomation.HorizonView -ErrorAction Stop
Import-Module 'C:\Scripts\VMware.Hv.Helper\VMware.HV.Helper.psm1' -ErrorAction Stop

$username = "administrator@vsphere.local"
$password = ConvertTo-SecureString -AsPlainText -Force "supercalifragilisticexpialidocious"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$horizonserver = "horizon.server.fqdn"

$hvServer = Connect-HVServer -Server $horizonserver -Credential $credentials -ErrorAction Stop
$Global:hvServices = $hvServer.ExtensionData

# Get Horizon View Health Informations
$HorizonHealth = Get-HVHealth

Write-Output "globalstats HorizonServerName=""$($HorizonHealth.Name)"" "
Write-Output "globalstats HorizonServerVersion=""$($HorizonHealth.Version)"" "
Write-Output "globalstats HorizonServerBuild=""$($HorizonHealth.Build)"" "
Write-Output "globalstats HorizonServerStatus=""$($HorizonHealth.Status)"" "

Write-Output "globalstats HorizonCpuUsagePercentage=$($HorizonHealth.ResourcesData.CpuUsagePercentage)"
Write-Output "globalstats HorizonRAMUsagePercentage=$($HorizonHealth.ResourcesData.MemoryUsagePercentage)"

Disconnect-HVServer -Server $horizonserver -Force -Confirm:$false 
