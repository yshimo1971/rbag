#!/usr/local/bin/ruby
# -*- encoding:utf-8 -*-
$: << '/opt/rrdtool-1.4.7/lib/ruby/1.9.1/x86_64-linux'
require 'RRD'
require 'date'
require 'csv'

name ="temp"
rrd = "#{name}.rrd"

puts "creating #{rrd}"
RRD.create(
  rrd,
  "--start", "#{Time.new(2012,6,1,0,0,0).to_i}",
  "--step", "#{(Time.new(2012,6,2,0,0,0)-Time.new(2012,6,1,0,0,0)).to_i}",
  "DS:temp:GAUGE:#{60*60*24*2}:U:U",
  "RRA:AVERAGE:0.5:1:3600"
)

puts "Append #{rrd}"
CSV.foreach('edogawa.csv') do |row|
    (month, day, temp) = row
   RRD.update(rrd, "#{Time.new(2012, month.to_i, day.to_i, 12, 0, 0).to_i}:#{temp.to_f}")
end

puts "generating graph #{name}.png"
RRD.graph(
    "#{name}.png",
    "--title", "江戸川臨海 平均気温", 
    "--start", "#{Time.new(2012,6,1,0,0,0).to_i}",
    "--end", "#{Time.new(2012,7,31,23,59,59).to_i}",
    "--interlace", 
    "--imgformat", "PNG",
    "--width=600",
    "COMMENT:2012年6月1日～2012年7月31日\\c",
    "DEF:temp=#{rrd}:temp:AVERAGE",
    "AREA:temp#00b6e4:平均気温",
)
