# -*- coding: windows-31j -*-
require 'win32ole'

ie = WIN32OLE.new('InternetExplorer.Application')
ie.Navigate("http://www.seshop.co.jp")
ie.Visible = false

while ie.busy
	sleep 1
end

printf "�^�C�g��: %s\n", ie.document.title
printf "�h���C����: %s\n", ie.document.domain
printf "�����R�[�h: %s\n", ie.document.charSet