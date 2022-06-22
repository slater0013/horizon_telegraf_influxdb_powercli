Import-Module -Name VMware.VimAutomation.HorizonView -ErrorAction Stop
Import-Module 'C:\Scripts\VMware.Hv.Helper\VMware.HV.Helper.psm1' -ErrorAction Stop

$username = "administrator@vsphere.local"
$password = ConvertTo-SecureString -AsPlainText -Force "supercalifragilisticexpialidocious"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$vcenterserver = "vcenter.fqdn"
$clustername = "clustername"
Connect-VIServer -Server $vcenterserver -Credential $credentials -ErrorAction Stop

# Get every ESXi Host 
$esxis = Get-Cluster -Name $clusternme | Get-VMHost

foreach($esxi in $esxis)
{
    $cpuPercentage = ($esxi.CpuUsageMhz / $esxi.CpuTotalMhz) * 100
    $ramPercentage = ($esxi.MemoryUsageGB / $esxi.MemoryTotalGB) * 100

    Write-Output "esxistats,esxi=$($esxi.Name) CpuUsageMhz=$($esxi.CpuUsageMhz)"
    Write-Output "esxistats,esxi=$($esxi.Name) CpuTotalMhz=$($esxi.CpuTotalMhz)"
    Write-Output "esxistats,esxi=$($esxi.Name) CpuUsagePercentage=$($cpuPercentage)"

    Write-Output "esxistats,esxi=$($esxi.Name) MemoryUsageGB=$($esxi.MemoryUsageGB)"
    Write-Output "esxistats,esxi=$($esxi.Name) MemoryTotalGB=$($esxi.MemoryTotalGB)"
    Write-Output "esxistats,esxi=$($esxi.Name) MemoryUsagePercentage=$($ramPercentage)"

    if($esxi.ConnectionState -eq "Connected")
    {
        Write-Output "esxistats,esxi=$($esxi.Name) ConnectionState=0"
    }else{
        Write-Output "esxistats,esxi=$($esxi.Name) ConnectionState=1"
    }
}

# Get Latest VSAN Statitstics
$vsanstats = Get-VsanStat -Entity $clustername -PredefinedTimeRange Last5Minutes

foreach($vsanstat in $vsanstats)
{
    Write-Output "vsanstats $($vsanstat.Name)=$($vsanstat.Value)"
}

Disconnect-VIServer -Server $vcenterserver -Confirm:$false
