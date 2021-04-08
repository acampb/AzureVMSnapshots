[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $SourceDiskName,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName,

    # Parameter help description
    [Parameter(Mandatory = $false)]
    [string]
    $SnapshotName = $SourceDiskName + "_snapshot"
)

$sourceDisk = Get-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $SourceDiskName

Write-Verbose "Creating snapshot configuration"
$snapshotConfig = New-AzSnapshotConfig -SourceUri $sourceDisk.Id -Location $sourceDisk.Location -CreateOption Copy

Write-Verbose "Creating disk snapshot"
$snapshot = New-AzSnapshot -ResourceGroupName $ResourceGroupName -SnapshotName $SnapshotName -Snapshot $snapshotConfig

$obj = [PSCustomObject]@{
    ResourceId = $snapshot.Id
}
Write-Output $obj