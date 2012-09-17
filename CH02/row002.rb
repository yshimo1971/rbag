# -*- coding: windows-31j -*-
require 'win32ole'

excel = WIN32OLE.new('Excel.Application')
excel.Visible = true

book = excel.Workbooks.Add()
sheet = book.ActiveSheet

(1..3).each do |row|
	(1..5).each do |column|
		cell = sheet.Cells.Item(row, column)
		cell.Value = "#{cell.Row}, #{cell.Column}"
	end
end
