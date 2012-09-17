# -*- coding: windows-31j -*-
require 'win32ole'
require 'erb'
require 'logger'
require 'net/scp'

REMOTE_HOST = "192.168.0.81"
REMOTE_USER = "root"
REMOTE_PASSWORD = "3Genja8e"

PXELINUX_PATH = "/var/lib/tftpboot/linux-install/pxelinux.cfg"
CFG_PATH = "/var/www/html"

def getAbsolutePath filename
    fso = WIN32OLE.new('Scripting.FileSystemObject')
    fso.GetAbsolutePathName(filename)
end

class Object
    @@logger = Logger.new(STDOUT)
    @@logger.level = Logger::WARN
    @@scp = NIL

    def logger()
        @@logger
    end

    def scp
        @@scp ||= Net::SCP.start(REMOTE_HOST, REMOTE_USER, :password => REMOTE_PASSWORD)
    end
end

class Host
    attr_accessor :hostname, :ip, :netmask, :gateway, :nameserver, :mac, :password, :root, :swap, :home

    def make_pxelinux_file
        erb = ERB.new(File.read("default.erb"))
        scp.upload!(StringIO.new(erb.result(binding)), "#{PXELINUX_PATH}/#{pxelinux_filename}")
        logger.warn("copy #{REMOTE_HOST}:#{PXELINUX_PATH}/#{pxelinux_filename} as boot file")
    end

    def make_cfg_file
        erb = ERB.new(File.read("kickstart.cfg.erb"))
        scp.upload!(StringIO.new(erb.result(binding)), "#{CFG_PATH}/#{pxelinux_filename}.cfg")
        logger.warn("copy #{REMOTE_HOST}:#{CFG_PATH}/#{pxelinux_filename}.cfg as config file")
    end

    def pxelinux_filename
        "01-" + @mac.gsub(":","-")
    end

    def make_kickstart_files
        make_pxelinux_file
        make_cfg_file
    end
end

class Hosts < Array
    def self.get_host_info(filename)
        filename = getAbsolutePath(filename)
        excel = WIN32OLE.new('Excel.Application')
        book = excel.Workbooks.Open(filename)
        logger.warn("Open #{filename}")
        sheet = book.ActiveSheet
        hosts = Hosts.new()

        labels = ['@hostname', '@ip', '@netmask', '@gateway', '@nameserver', '@mac', '@password', '@root', '@swap', '@home']
        (2..sheet.UsedRange.Rows.Count).each do |row|
            host = Host.new
            labels.each_with_index do |label, column|
                host.instance_variable_set(label, sheet.Cells.Item(row, column + 1).Value)
            end
            hosts.push(host)
        end
        book.Close
        excel.Quit
        hosts
    end
end

def main()
    Hosts.get_host_info("c:\\src\\test\\centos.xls").each do |host|
        host.make_kickstart_files
    end
end

main