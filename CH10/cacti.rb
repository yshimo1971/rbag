# -*- encondig:utf-8 -*-

class Cacti
    @@php = "/usr/bin/php"
    @@add_tree = "/usr/share/cacti/cli/add_tree.php"
    @@hosts = Hash.new()

    def self._hosts
        return @@hosts if !@@hosts.empty?()
        option = "--list-hosts"
        `#{@@php} #{@@add_tree} #{option}`.split(/\n/).values_at(1..-1).each do |line|
            (id, hostname, template, description) = line.split(/\t/)
            @@hosts.store(description, {:id=> id, :template => template, :hostname => hostname, :graphs => self._graphs(id)})

        end
        @@hosts
    end

    def self._graphs(id)
        _graphs = Hash.new()
        option = "--list-graphs --host-id=#{id}"
        `#{@@php} #{@@add_tree} #{option}`.split(/\n/).values_at(1..-1).each do |line|
            (id, name, template) = line.split(/\t/)
            _graphs.store(id,{:name => name, :template => template})
        end
        _graphs
    end

    def self.hosts
        self._hosts.keys
    end

    def self.graph_ids(host)
        self._hosts[host][:graphs].keys
    end
end
