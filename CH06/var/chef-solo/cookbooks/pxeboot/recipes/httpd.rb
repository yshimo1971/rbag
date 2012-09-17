#
# Cookbook Name:: pxeboot
# Recipe:: httpd
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

yum_package "httpd" do
    action :install
end

cookbook_file "/etc/httpd/conf.d/pxeboot.conf" do
    owner "apache"
    group "apache"
    mode "644"
    source "pxeboot.conf"
end

replace "/etc/httpd/conf/httpd.conf" do
    pattern "#ServerName www.example.com:80" 
    replacement "ServerName #{node['ipaddress']}"
end

service "httpd" do
    action [:enable, :start] 
end
