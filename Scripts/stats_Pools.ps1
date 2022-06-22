Import-Module -Name VMware.VimAutomation.HorizonView -ErrorAction Stop
Import-Module 'C:\Scripts\VMware.Hv.Helper\VMware.HV.Helper.psm1' -ErrorAction Stop

$horizonserver = "horizon.server.fqdn"

$username = "administrator@vsphere.local"
$password = ConvertTo-SecureString -AsPlainText -Force "Supercalifragilisticexpialidocious"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$hvServer = Connect-HVServer -Server $horizonserver -Credential $credentials -ErrorAction Stop
$Global:hvServices = $hvServer.ExtensionData

#Getting Horizon View Pools Summary
$pools = Get-HVPoolSummary

#Global counters
$sum_nummachines = 0;
$sum_numsessions = 0;
$sum_maxmachines = 0;

foreach($pool in $pools)
{
    #Getting Pool Details
    $poolstat = $pool.DesktopSummaryData
    $hvpool = Get-HVPool -PoolName $poolstat.Name
    
    $sum_nummachines += [int]$poolstat.NumMachines
    $sum_numsessions += [int]$poolstat.NumSessions
    $sum_maxmachines += [int]$hvpool.AutomatedDesktopData.VmNamingSettings.PatternNamingSettings.MaxNumberOfMachines
    
    Write-Output "poolstats,pool=$($poolstat.Name) NumMachines=$([int]$poolstat.NumMachines)"
    Write-Output "poolstats,pool=$($poolstat.Name) NumSessions=$([int]$poolstat.NumSessions)"
    Write-Output "poolstats,pool=$($poolstat.Name) MaxMachines=$([int]$hvpool.AutomatedDesktopData.VmNamingSettings.PatternNamingSettings.MaxNumberOfMachines)"
}

Write-Output "poolstats SumNumMachines=$($sum_nummachines)"
Write-Output "poolstats SumNumSessions=$($sum_numsessions)"
Write-Output "poolstats SumMaxMachines=$($sum_maxmachines)"

Disconnect-HVServer -Server $horizonserver -Force -Confirm:$false 
