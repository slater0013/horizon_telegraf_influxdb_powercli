Import-Module -Name VMware.VimAutomation.HorizonView -ErrorAction Stop
Import-Module 'C:\Scripts\VMware.Hv.Helper\VMware.HV.Helper.psm1' -ErrorAction Stop

$username = "administrator@vsphere.local"
$password = ConvertTo-SecureString -AsPlainText -Force "supercalifragilisticexpialidocious"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$vcenterserver = "vcenter.fqdn"
$hvServer = Connect-HVServer -Server $vcenterserver -Credential $credentials -ErrorAction Stop

$Global:hvServices = $hvServer.ExtensionData

$pools = Get-HVPool

//List of non-affected pools
$critical_pools = @('ITPool', 'HRPool')

foreach($pool in $pools)
{
    if( $critical_pools -inotcontains $pool.Base.Name )
    {
        #Write-Output "Enable/Disable $($pool.Base.Name) / $($pool.Base.DisplayName)"
        $pool | Set-HVPool -Enable
        $pool | Set-HVPool -Start
    }
}

Disconnect-HVServer -Server vcenterserver -Force -Confirm:$false
