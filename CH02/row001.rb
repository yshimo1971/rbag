# -*- coding: windows-31j -*-
require 'win32ole'

excel = WIN32OLE.new('Excel.Application')
excel.Visible = true

book = excel.Workbooks.Add()
sheet = book.ActiveSheet

sheet.Range("A1:E3").Rows.each do |rows|
	rows.Columns.each do |cell|
		cell.Value = "#{cell.Row}, #{cell.Column}"
	end
end