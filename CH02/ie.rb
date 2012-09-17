# -*- coding: windows-31j -*-
require 'win32ole'

ie = WIN32OLE.new('InternetExplorer.Application')
ie.Navigate("http://www.seshop.co.jp")
ie.Visible = false

while ie.busy
	sleep 1
end

printf "タイトル: %s\n", ie.document.title
printf "ドメイン名: %s\n", ie.document.domain
printf "文字コード: %s\n", ie.document.charSet