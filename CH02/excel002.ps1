function getAbsolutePath($filename) {
	$fso = New-Object -comobject Scripting.FileSystemObject
	return $fso.GetAbsolutePathName($filename)
}

$filename = getAbsolutePath("urllist.xls")

$excel = New-Object -comobject Excel.Application
$excel.Visible = $False

$book = $excel.Workbooks.Open($filename)
$sheet = $book.ActiveSheet

$ie = New-Object -comobject InternetExplorer.Application
for ($row = 2; $row -le $sheet.UsedRange.Rows.Count; $row++) {

	$url =  $sheet.Cells.Item($row, 1).Text

	$ie.Navigate($url)
	$ie.Visible = $False

	while ($ie.busy) {
		sleep 1
	}

	$sheet.Cells.Item($row, 2) = $ie.document.title
	$sheet.Cells.Item($row, 3)= $ie.document.domain
	$sheet.Cells.Item($row, 4) = $ie.document.URL
	$sheet.Cells.Item($row, 5) = $ie.document.charSet
	$sheet.Cells.Item($row, 6) = $ie.document.lastModified

}

$book.Save()
$book.Close()
$excel.Quit()
$ie.Quit()
[GC]::Collect() 