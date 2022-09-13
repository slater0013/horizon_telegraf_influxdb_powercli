Import-Module -Name VMware.VimAutomation.HorizonView -ErrorAction Stop
Import-Module 'C:\Scripts\VMware.Hv.Helper\VMware.HV.Helper.psm1' -ErrorAction Stop

$username = "administrator@vsphere.local"
$password = ConvertTo-SecureString -AsPlainText -Force "supercalifragilisticexpialidocious"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$horizonserver = "horizon.server.fqdn"
$hvServer = Connect-HVServer -Server $horizonserver -Credential $credentials -ErrorAction Stop

$Global:hvServices = $hvServer.ExtensionData

$pools = Get-HVPool 

//List of non-affected pools
$critical_pools = @('ITPool', 'HRPool')

foreach($pool in $pools)
{
    if( $pools_a_conserver -inotcontains $pool.Base.Name )
    {
        #Disable new pool access & Disable InstantClone VM provisionning
        $pool | Set-HVPool -Disable
        $pool | Set-HVPool -Stop

        #List VMs for each pool
        $machines = Get-HVMachine -PoolName $pool.Base.Name
        foreach($machine in $machines)
        {
            #If someone is connected, don't kill the session.
            if ($machine.Base.BasicState -ne "CONNECTED")
            {
                Remove-HVMachine $machine.Base.Name -DeleteFromDisk -Confirm:$false
            }
        }
    }
}

Disconnect-HVServer -Server $horizonserver -Force -Confirm:$false
