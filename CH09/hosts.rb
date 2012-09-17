# -*- encondig: windows-31j -*-

class Net::Telnet
    alias login_org login
    def login(options, password = nil)
        options ||= Hash.new
        if options.kind_of?(Hash) and !options["Name"]
            options["Name"] = options["Password"] ? options["Password"] : password
            options["LoginPrompt"] = /[Pp]ass(?:word|phrase)[: ]*\z/n
            options["Password"] = nil
            options["PasswordPrompt"] = nil
        end
        login_org(options, password)
    end
end

class Host
    def initialize(options)
        @options = options
    end

    def connect
        @telnet = Net::Telnet.new(@options)
        @telnet.login(@options)
    end

    def close
        connection.close
    end

    def connection
        @telnet if @telnet
    end

    def cmd(command, keyword = nil )
        lines = connection.cmd(command).split(/\n/).values_at(1..-2)
        lines if !keyword
        result = nil
        lines.each do |line|
            result = $1 if line =~ keyword
        end
        result.strip
    end
end

class Foundary < Host
    def initialize(options, password = nil)
        if options.kind_of?(String)
            name = options
            options = Hash.new
            options["Name"] = name
            options["Password"] = password
        end
        options["Prompt"] = /[$%#>]\z/n
        options["LoginPrompt"] = /[Uu]sername[: ]*\z/n
        options["PasswordPrompt"] = /[Pp]assword[: ]*\z/n
        super(options)
    end

    def model_no
        cmd("show system", /System description: (.*)/)
    end

    def mac_address
        cmd("show system", /MAC address\s+: (.*)/)
    end
    
    def serial_no
    	cmd("show version", /Serial number\s+:(.*)/)
    end

end

class Linux < Host
    def model_no
        cmd("cat /etc/redhat-release", /(.*)/)
    end

    def mac_address
        cmd("ifconfig eth0", /HWaddr (.*)/)
    end

    def serial_no
    	return "#N/A"
    end
end