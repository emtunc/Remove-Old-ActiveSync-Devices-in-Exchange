$searchDays = Read-Host -prompt "A device is considered 'stale' if it has not synchronised in how many days?"
$confirmation = Read-Host Read-Host "Devices that have not synchronised with Exchange since" (Get-Date).AddDays(-$searchDays) "will be deleted. Press Y to confirm"
if ($confirmation -eq 'Y') {
$staleDevices = Get-Mailbox | ForEach {Get-ActiveSyncDeviceStatistics -Mailbox:$_.Identity} | where {$_.LastSuccessSync -lt ((Get-Date).AddDays(-$searchDays))} | select -expand Identity
foreach ($device in $staleDevices) {Remove-ActiveSyncDevice -Identity $device -confirm:$false}
}
write-host "Aborted. You did not confirm the deletion." -ForegroundColor Red