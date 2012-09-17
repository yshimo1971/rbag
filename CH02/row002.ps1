$excel = New-Object -comobject Excel.Application
$excel.Visible = $True

$book = $excel.Workbooks.Add()
$sheet = $book.ActiveSheet

for($row = 1; $row -le 3; $row++) {
	for($column = 1; $column -le 5; $column++) {
		$cell = $sheet.Cells.Item($row, $column)
		$cell.Value2 = "{0}, {1}" -f $cell.Row, $cell.Column
	}
}