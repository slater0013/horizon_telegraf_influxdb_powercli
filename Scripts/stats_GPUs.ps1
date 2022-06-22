Import-Module -Name VMware.VimAutomation.HorizonView -ErrorAction Stop
Import-Module 'C:\Scripts\VMware.Hv.Helper\VMware.HV.Helper.psm1' -ErrorAction Stop

$username = "administrator@vsphere.local"
$password = ConvertTo-SecureString -AsPlainText -Force "supercalifragilisticexpialidocious"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$vcenterserver = "vcenter.fqdn"
Connect-VIServer -Server $vcenterserver -Credential $credentials -ErrorAction Stop

$esxis = get-VMHost
foreach($esxi in $esxis)
{
    $gpustats = Get-Stat -Entity $esxi -Stat "gpu*" -MaxSamples 1 -IntervalMins 1
    foreach($gpustat in $gpustats)
    {
        Write-Output "gpustats,esxi=$($esxi.Name),gpu=$($gpustat.Instance) $($gpustat.MetricId)=$($gpustat.Value)"
    }
}

Disconnect-VIServer -Server $vcenterserver -Force -Confirm:$false
