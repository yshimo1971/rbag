Add-PSSnapin VMware.VimAutomation.Core

$server = "vcenter.kasai.local"
$user ="Administrator"
$password = "XxXxXxXx"

$vc = Connect-VIServer -Server $server -User $user -Password $password

function getAbsolutePath($filename) {
	$fso = New-Object -comobject Scripting.FileSystemObject
	return $fso.GetAbsolutePathName($filename)
}

$filename = getAbsolutePath("c:\src\test\template-vm.xls")

$excel = New-Object -comobject Excel.Application
$excel.Visible = $True
$book = $excel.Workbooks.Open($filename)

$sheet = $book.Worksheets.Item("WS")
for ($row = 2; $row -le $sheet.UsedRange.Rows.Count; $row++) {

	$Name = $sheet.Cells.Item($row, 1).Value2
	$VMhost = $sheet.Cells.Item($row, 2).Value2
	$Template = $sheet.Cells.Item($row, 3).Value2
	$IpAddress = $sheet.Cells.Item($row, 4).Value2
	$SubnetMask = $sheet.Cells.Item($row, 5).Value2
	$DefaultGateway = $sheet.Cells.Item($row, 6).Value2
	$Dns = $sheet.Cells.Item($row, 7).Value2
	$Wins = $sheet.Cells.Item($row, 8).Value2
	$FullName = $sheet.Cells.Item($row, 9).Value2
	$OrgName = $sheet.Cells.Item($row, 10).Value2
	$ProductKey = $sheet.Cells.Item($row, 11).Value2
	$AdminPassword = $sheet.Cells.Item($row, 12).Value2

	Write-Host ("Creating New VM {0} in {1} from {2} ..." -f $Name, $VMHost, $Template)

	$OSCustomizationSpec = New-OSCustomizationSpec `
	    -Name "$Name-spec" `
	    -OSType Windows `
	    -FullName $FullName `
	    -OrgName $OrgName `
	    -ProductKey $ProductKey `
	    -LicenseMode PerSeat `
	    -Workgroup Workgorup `
	    -ChangeSid `
	    -TimeZone Tokyo `
	    -AdminPassword $AdminPassword `
	    -Type NonPersistent `
	    -NamingScheme Vm `
	    -Server $vc

	Get-OSCustomizationSpec $OSCustomizationSpec |
        Get-OSCustomizationNicMapping | 
        Set-OSCustomizationNicMapping `
	    -IpMode UseStaticIP `
	    -IpAddress $IpAddress `
	    -Subnetmask $SubnetMask `
	    -DefaultGateway $DefaultGateway `
	    -Dns $Dns `
            -Wins $Wins

	New-VM `
		-Name $Name `
		-VMHost (Get-VMHost -Name $VMhost) `
		-Template (Get-Template -Name $Template) `
		-OSCustomizationSpec $OSCustomizationSpec

	Remove-OSCustomizationSpec $OSCustomizationSpec -Confirm:$false

	$sheet.Cells.Item($row, 13) = "çÏê¨çœÇ›"
}

$book.Save()
$book.Close()
$excel.Quit()
Disconnect-VIServer -Server $vc -Confirm:$False
[GC]::Collect() 