# -*- encondig: windows-31j -*-
$: << File.dirname(__FILE__)

require 'win32ole'
require 'net/telnet'
require 'hosts.rb'

def getAbsolutePath filename
	fso = WIN32OLE.new('Scripting.FileSystemObject')
	fso.GetAbsolutePathName(filename)
end

filename = getAbsolutePath("hostsinfo.xls")
excel = WIN32OLE.new('Excel.Application')
excel.Visible = false
book = excel.Workbooks.Open(filename)
sheet = book.WorkSheets("hostsinfo")

labels = Array.new
(1..sheet.UsedRange.Columns.Count).each do |column|
	labels << sheet.Cells.Item(1, column).Value
end

options = Array.new
(2..sheet.UsedRange.Rows.Count).each do |row|
	option = Hash.new
	labels.each_with_index do |label, column|
		option.store(label, sheet.Cells.Item(row, column + 1).Value)
	end
	options.push(option)
end

sheet = book.WorkSheets("results")
options.each_with_index do |option, row|
    host = eval("#{option["Type"]}.new(option)")
	host.connect
    sheet.Cells.Item(row + 2, 1).Value = option["Host"]
    sheet.Cells.Item(row + 2, 2).Value = host.model_no
    sheet.Cells.Item(row + 2, 3).Value = host.mac_address.gsub("-", ":")
    sheet.Cells.Item(row + 2, 4).Value = host.serial_no
    host.close
end

excel.DisplayAlerts = false
book.Save
book.Close
excel.DisplayAlerts = true
excel.Quit