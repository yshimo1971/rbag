#
# Cookbook Name:: pxeboot
# Recipe:: default
#
# Copyright 2012, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

require 'pp'
%w{ xinetd tftp-server syslinux }.each do |pkg|
    yum_package pkg do
        action :install
    end
end

%w{ xinetd tftp }.each do |serv|
    service serv do
        action [:enable, :start] if serv == "xinetd"
        action :enable if serv == "tftp"
    end
end

directory "#{node.pxeroot}" do
    owner "root"
    group "root"
    mode "0655"
    action :create
end

file "#{node.pxeroot}/pxelinux.0" do
    owner "root"
    group "root"
    mode "0644"
    content IO.read(node.pxelinux.source) if File.exists?(node.pxelinux.source)
    action :create
end

%w{vmlinuz initrd.img}.each do |filename|
    file "#{node.pxeroot}/#{filename}" do
        owner "root"
        group "root"
        mode "0644"
        content IO.read("#{node.media}/#{filename}")
        action :create
    end
end

template "#{node.pxeroot}/default" do
    source "default.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
        :filename => "default"
    )
end
