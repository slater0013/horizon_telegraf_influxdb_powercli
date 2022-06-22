# horizon_telegraf_influxdb_powercli
Using Powershell Scripts and PowerCLI to grab usage statistics from Vmware Horizon Services

## Powershell Modules

Tested with Windows Server 2019 Standard and included Powershell 5.1

You need to install VMware.VimAutomation.HorizonView module :
<code>PS > Install-Module -Name VMware.VimAutomation.HorizonView</code>

## Scripts folder

Mixing Powershell/PowerCLI - Called by telegraf - Generates InfluxDB line protocol

- stats_Pools : For each Horizon Pool, get number of machines/sessions/maxMachines (+ global sums)
- stats_Sessions : For each Horizon Session, get cpu/ram usage and latency/IOPS 
- stats_Horizon : Get Horizon Server Identity (Name/Version-Build) and CPU/RAM Usage
- stats_ESXI : For each ESXi server in the vCenter, get CPU/RAM Usage, Connection Status and vSAN statistics.
- stats_Inventory : For each Horizon Pool, get Pool names, Golden VM name, snapshot and ActiveDirectory OU Path
- stats_GPU : For each ESXi server in the vCenter, get Memory/GPU Usage and temperature

## Grafana folder 

You can find json exported dashboards

