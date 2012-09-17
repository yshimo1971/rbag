# -*- coding: windows-31j -*-
require 'win32ole'

def getAbsolutePath filename
	fso = WIN32OLE.new('Scripting.FileSystemObject')
	fso.GetAbsolutePathName(filename)
end

filename = getAbsolutePath("urllist.xls")
excel = WIN32OLE.new('Excel.Application')
excel.Visible = false

book = excel.Workbooks.Open(filename)
sheet = book.ActiveSheet

(2..sheet.UsedRange.Rows.Count).each do |row|
	url = sheet.Cells.Item(row, 1).Value

	ie ||= WIN32OLE.new('InternetExplorer.Application')
	ie.Navigate(url)
	ie.Visible = false

	while ie.busy
		sleep 1
	end

	sheet.Cells.Item(row, 2).Value = ie.document.title
	sheet.Cells.Item(row, 3).Value = ie.document.domain
	sheet.Cells.Item(row, 4).Value = ie.document.URL
	sheet.Cells.Item(row, 5).Value = ie.document.charSet
	sheet.Cells.Item(row, 6).Value = ie.document.lastModified

end

book.Save
book.Close
excel.Quit