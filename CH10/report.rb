#!/usr/bin/ruby
# -*- encodnig:utf-8 -*-
$: << File.dirname(__FILE__)

require 'rubygems'
require 'open-uri'
require 'optparse'
require 'thinreports'
require 'cacti.rb'

def graph_image(*params)
    url = "http://192.168.36.141/cacti/graph_image.php?"
    open(url + URI.encode(params.join('&')))
end

opts = Hash.new()
ARGV.options do |o|
    o.banner = "ruby #{$0} [options] [args]"
    o.on("-f filename", "--filename", "Output PDF filename"){|x| opts[:filename] = x}
    o.on("-l layout", "--layout", "Thin Report Layout filename"){|x| opts[:layout] = x}
    o.on("-h hostname", "--host", "Host Name"){|x| opts[:hostname] = x}
    o.parse!
end

ThinReports::Report.generate_file(opts[:filename],:layout => opts[:layout]) do
    (opts[:hostname] ? [opts[:hostname]] : Cacti::hosts).each do |host|
        length = 2
        start_new_page
        page.item(:date).value(Time.now().strftime("%Y/%m/%d"))
        page.list(:list).header.item(:hostname).value("ホスト名:#{host}")
        Cacti::graph_ids(host).each do |id|
            page.list(:list).add_row do |row|
                row.item(:title).value(Cacti::graph_title(host, id))
                row.item(:graph).src(
                    graph_image(
                        "action=zoom",
                        "local_graph_id=#{id}",
                        "rra_id=0",
                        "view_type=tree",
                        "graph_width=#{555-100}",
                        "graph_height=#{80}",
                        "graph_start=#{(Time.now()-(3600*length)).to_i}",
                        "graph_end=#{Time.now().to_i}"
                       )
                  )
            end
        end
    end
end

