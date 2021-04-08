[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $SnapshotResourceId,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $Location,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $DiskName,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $VMName,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName

)

Write-Verbose "Creating new disk"
$newDiskConfig = New-AzDiskConfig -Location $Location -CreateOption Copy -SourceResourceId $SnapshotResourceId
$newdisk = New-AzDisk -DiskName $DiskName -Disk $newDiskConfig -ResourceGroupName $ResourceGroupName -Verbose

Write-Verbose "Stopping virtual machine $VMName"
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
Stop-AzVM -Name $vm.Name -ResourceGroupName $ResourceGroupName -Verbose -Force

Write-Verbose "Updating OS disk"
Set-AzVMOSDisk -VM $vm -ManagedDiskId $newdisk.Id -Name $newdisk.Name -Verbose
Update-AzVM -VM $vm -ResourceGroupName $ResourceGroupName -Verbose

Write-Verbose "Starting virtual machine $VMName"
Start-AzVM -Name $vm.Name -ResourceGroupName $ResourceGroupName -Verbose