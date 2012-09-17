Add-PSSnapin VMware.VimAutomation.Core

$server = "vcenter.kasai.local"
$user ="Administrator"
$password = "XxXxXxXx"

$vc = Connect-VIServer -Server $server -User $user -Password $password

function getAbsolutePath($filename) {
	$fso = New-Object -comobject Scripting.FileSystemObject
	return $fso.GetAbsolutePathName($filename)
}

$filename = getAbsolutePath("c:\src\test\new-vm.xls")

$excel = New-Object -comobject Excel.Application
$excel.Visible = $True

$book = $excel.Workbooks.Open($filename)
$sheet = $book.ActiveSheet

for ($row = 2; $row -le $sheet.UsedRange.Rows.Count; $row++) {
	$name = $sheet.Cells.Item($row, 1).Value2
	$guestid = $sheet.Cells.Item($row, 2).Value2
	$vmhost = $sheet.Cells.Item($row, 3).Value2
	$numcpu = $sheet.Cells.Item($row, 4).Value2
	$memorymb = $sheet.Cells.Item($row, 5).Value2 * 1024
	$datastore = $sheet.Cells.Item($row, 6).Value2
	$diskmb = $sheet.Cells.Item($row, 7).Value2 * 1024
	$diskstorageformat = $sheet.Cells.Item($row, 8).Value2

	Write-Host "Creating New VM $name in $vmhost..."
	New-VM -Name $name -vmhost (Get-VMHost -Name $vmhost) -Datastore $datastore -NumCpu $numcpu -DiskMB $diskmb -MemoryMB $memorymb -DiskStorageFormat $diskstorageformat -GuestID $guestid

	$sheet.Cells.Item($row, 9) = "çÏê¨çœÇ›"
}

$book.Save()
$book.Close()
$excel.Quit()
Disconnect-VIServer -Server $vc -Confirm:$False
[GC]::Collect()