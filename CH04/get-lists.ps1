Add-PSSnapin VMware.VimAutomation.Core

$server = "vcenter.kasai.local"
$user ="Administrator"
$password = "XxXxXxXx"

$vc = Connect-VIServer -Server $server -User $user -Password $password

function getAbsolutePath($filename) {
	$fso = New-Object -comobject Scripting.FileSystemObject
	return $fso.GetAbsolutePathName($filename)
}

$filename = getAbsolutePath("c:\src\test\vmlist-{0:yyyyMMdd-hhmmss}.xls" -f (Get-Date))

$excel = New-Object -comobject Excel.Application
$excel.Visible = $True

# 仮想マシン情報取得
$book = $excel.Workbooks.Add()
$sheet = $book.Worksheets.Item(1)
$sheet.Name = "仮想マシン"
$fields = "Name","NumCpu","MemoryMB","UsedSpaceGB","ProvisionedSpaceGB","VMHost","NetworkAdapters","PowerState"
$lables = "仮想マシン名","CPU数","メモリ(MB)","ディスク利用量","ディスク割当量","動作ホスト","ネットワークアダプタ","状態"

$column = 1
foreach ($label in $lables) {
	$sheet.Cells.Item(1, $column) = $label
	$column++
}

$row = 2
Get-VM | Select-Object $fields | ForEach-Object -Process {
	$sheet.Cells.Item($row, 1) = "{0}" -f $_.Name
	$sheet.Cells.Item($row, 2) = "{0}" -f $_.NumCpu
	$sheet.Cells.Item($row, 3) = "{0}" -f $_.MemoryMB
	$sheet.Cells.Item($row, 4) = "{0:#.00}" -f $_.UsedSpaceGB
	$sheet.Cells.Item($row, 5) = "{0:#.00}" -f $_.ProvisionedSpaceGB
	$sheet.Cells.Item($row, 6) = "{0}" -f $_.VMHost
	$sheet.Cells.Item($row, 7) = "{0}" -f $_.NetworkAdapters
	$sheet.Cells.Item($row, 8) = "{0}" -f $_.PowerState
	$row++
}

# ESXホスト情報取得
$sheet = $book.Worksheets.Item(2)
$sheet.Name = "ESXホスト"
$fields = "Name","ConnectionState","PowerState","CpuTotalMhz","CpuUsageMhz","MemoryTotalMB","MemoryUsageMB","Version"
$lables = "ホスト名","接続","電源状態","CPU総量(Mhz)","CPU使用量(Mhz)","メモリ総量(MB)", "メモリ使用量(MB)","ESXバージョン"

$column = 1
foreach ($label in $lables) {
	$sheet.Cells.Item(1, $column) = $label
	$column++
}

$row = 2
Get-VMHost | Select-Object $fields | ForEach-Object -Process {
	$sheet.Cells.Item($row, 1) = "{0}" -f $_.Name
	$sheet.Cells.Item($row, 2) = "{0}" -f $_.ConnectionState
	$sheet.Cells.Item($row, 3) = "{0}" -f $_.PowerState
	$sheet.Cells.Item($row, 4) = "{0:#.00}" -f $_.CpuTotalMhz
	$sheet.Cells.Item($row, 5) = "{0:#.00}" -f $_.CpuUsageMhz
	$sheet.Cells.Item($row, 6) = "{0:#.00}" -f $_.MemoryTotalMB
	$sheet.Cells.Item($row, 7) = "{0:#.00}" -f $_.MemoryUsageMB
	$sheet.Cells.Item($row, 8) = "{0}" -f $_.Version
	$row++
}

# データストア情報取得
$sheet = $book.Worksheets.Item(3)
$sheet.Name = "データストア"
$fields = "Name","FreeSpaceMB","CapacityMB"
$lables = "データストア名","空き容量(GB)","使用量(GB)", "全容量(GB)"

$column = 1
foreach ($label in $lables) {
	$sheet.Cells.Item(1, $column) = $label
	$column++
}

$row = 2
Get-Datastore | Select-Object $fields | ForEach-Object -Process {
	$sheet.Cells.Item($row, 1) = "{0}" -f $_.Name
	$sheet.Cells.Item($row, 2) = "{0:#.00}" -f ($_.CapacityMB / 1024)
	$sheet.Cells.Item($row, 3) = "{0:#.00}" -f ($_.FreeSpaceMB / 1024)
	$sheet.Cells.Item($row, 4) = "{0:#.00}" -f (($_.FreeSpaceMB + $_.CapacityMB) / 1024)
	$row++
}

$book.SaveAs($filename)
$book.Close()
$excel.Quit()
Disconnect-VIServer -Server $vc -Confirm:$False
[GC]::Collect() 
