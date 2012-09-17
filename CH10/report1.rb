#!/usr/bin/ruby
# -*- encodnig:utf-8 -*-
$: << File.dirname(__FILE__)

require 'rubygems'
require 'open-uri'
require 'cacti.rb'
require 'optparse'
require 'thinreports'

def graph_image(*params)
    url = "http://192.168.36.141/cacti/graph_image.php?"
    open(url + URI.encode(params.join('&')))
end

id = Cacti::graph_ids("Router")

opts = Hash.new()
ARGV.options do |o|
    o.banner = "ruby #{$0} [options] [args]"
    o.on("-f filename", "--filename", "Output PDF filename"){|x| opts[:filename] = x}
    o.on("-l layout", "--layout", "Thin Report Layout filename"){|x| opts[:layout] = x}
    o.on("-h hostname", "--host", "Host Name"){|x| opts[:hostname] = x}
    o.on("-i graphid", "--id", "Graph ID"){|x| opts[:id] = x}
    o.parse!
end

ThinReports::Report.generate_file(opts[:filename],:layout => opts[:layout]) do
    length = 2
    start_new_page
    page.item(:date).value(Time.now())
    page.item(:hostname).value(opts[:hostname])
    page.item(:graph).src(
        graph_image(
            "action=zoom",
            "local_graph_id=#{opts[:id]}",
            "rra_id=0",
            "view_type=tree",
            "graph_width=#{555-100}",
            "graph_height=#{80}",
            "graph_start=#{(Time.now()-(3600*length)).to_i}",
            "graph_end=#{Time.now().to_i}"
         )
     )
end


