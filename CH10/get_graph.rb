#!/usr/bin/ruby
# -*- encodnig:utf-8 -*-
$: << File.dirname(__FILE__)

require 'open-uri'
require 'cacti.rb'

def graph_image(*params)
    url = "http://192.168.36.141/cacti/graph_image.php?"
    open(url + URI.encode(params.join('&')))
end

id = Cacti::graph_ids("Router")

length = 1
File.open(ARGV[0], "wb") do |f|
    f.write graph_image(
		"action=zoom",
		"local_graph_id=#{id}",
		"rra_id=0",
		"view_type=tree",
		"graph_width=500",
		"graph_height=200",
		"graph_start=#{(Time.now-(3600*length)).to_i}",
		"graph_end=#{Time.now.to_i}"
    ).read
end
