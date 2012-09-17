$excel = New-Object -comobject Excel.Application
$excel.Visible = $True

$book = $excel.Workbooks.Add()
$sheet = $book.ActiveSheet

$sheet.Range("A1:E3").Rows | ForEach-Object -Process {
	$_.Columns | ForEach-Object -Process {
		$_.Value2 = "{0}, {1}" -f $_.Row, $_.Column
	}
}