Import-Module -Name VMware.VimAutomation.HorizonView -ErrorAction Stop
Import-Module 'C:\Scripts\VMware.Hv.Helper\VMware.HV.Helper.psm1' -ErrorAction Stop

$username = "administrator@vsphere.local"
$password = ConvertTo-SecureString -AsPlainText -Force "supercalifragilisticexpialidocious"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$horizonserver = "horizon.server.fqdn"
$vcenterserver = "vcenter.fqdn"

$hvServer = Connect-HVServer -Server $horizonserver -Credential $credentials -ErrorAction Stop
$connexion = Connect-VIServer -Server $vcenterserver -Credential $credentials -ErrorAction Stop

$Global:hvServices = $hvServer.ExtensionData
$performance = New-Object VMware.Hv.PerformanceService

#Get Horizon View Sessions
$sessions = Get-HVLocalSession

foreach($session in $sessions)
{
    #Get the latest performance datas
    $perfdatas = $performance.Performance_GetHistoricalPerformanceData($hvServices,$session.Id)
    $lastperf = $perfdatas[-1]
    
    Write-output "sessionstats,pool=$($session.NamesData.DesktopPoolCN),machine=$($session.NamesData.MachineOrRDSServerName) cpu=0$($lastperf.Cpu)"
    Write-output "sessionstats,pool=$($session.NamesData.DesktopPoolCN),machine=$($session.NamesData.MachineOrRDSServerName) ram=0$($lastperf.Memory)"
    Write-output "sessionstats,pool=$($session.NamesData.DesktopPoolCN),machine=$($session.NamesData.MachineOrRDSServerName) latency=0$($lastperf.Latency)"
    Write-output "sessionstats,pool=$($session.NamesData.DesktopPoolCN),machine=$($session.NamesData.MachineOrRDSServerName) iops=0$($lastperf.DiskIops)"
    Write-output "sessionstats,pool=$($session.NamesData.DesktopPoolCN),machine=$($session.NamesData.MachineOrRDSServerName) read_iops=0$($lastperf.DiskRreadIops)"
    Write-output "sessionstats,pool=$($session.NamesData.DesktopPoolCN),machine=$($session.NamesData.MachineOrRDSServerName) write_iops=0$($lastperf.DiskWriteIops)"
    Write-output "sessionstats,pool=$($session.NamesData.DesktopPoolCN),machine=$($session.NamesData.MachineOrRDSServerName) disk_latency=0$($lastperf.DiskLatency)"

}

Disconnect-HVServer -Server $horizonserver -Force -Confirm:$false
Disconnect-VIServer -Server $vcenterserver -Force -Confirm:$false
