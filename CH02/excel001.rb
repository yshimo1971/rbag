# -*- coding: windows-31j -*-
require 'win32ole'

def getAbsolutePath filename
	fso = WIN32OLE.new('Scripting.FileSystemObject')
	fso.GetAbsolutePathName(filename)
end

filename = getAbsolutePath("sample1.xls")
excel = WIN32OLE.new('Excel.Application')
book = excel.Workbooks.Open(filename)
sheet = book.ActiveSheet
puts sheet.Name
sheet.UsedRange.Rows.each do |row|
	cells = Array.new
	row.Columns.each do |cell|
		cells << cell.Value
	end
	puts cells.join(',')
end

book.Close
excel.Quit