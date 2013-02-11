#
# Cookbook Name:: sphinx
# Recipe:: default
#
# Author:: Maxim Kremenev <ezo@kremenev.com>
#
# Copyright 2013, Maxim Kremenev
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
include_recipe "build-essential"
include_recipe "mysql::client"      if node[:sphinx][:use_mysql]
include_recipe "postgresql::client" if node[:sphinx][:use_postgres]

# TODO: add it to not_if block
# `/usr/local/bin/searchd -h|head -n1|awk '{print $2}'` == node[:sphinx][:version]}
remote_file "/tmp/sphinx-#{node[:sphinx][:version]}.tar.gz" do
  source "#{node[:sphinx][:url]}"
  checksum node[:sphinx][:checksum]
  not_if { ::File.exist?('/usr/local/bin/searchd') }

end

execute "Extract Sphinx source" do
  cwd "/tmp"
  command "tar -zxvf /tmp/sphinx-#{node[:sphinx][:version]}.tar.gz"
  not_if { ::File.exist?('/usr/local/bin/searchd') }
end

bash "Build and Install Sphinx Search" do
  cwd "/tmp/sphinx-#{node[:sphinx][:version]}"
  code <<-EOH
    ./configure #{node[:sphinx][:configure_flags].join(" ")} && \
    make -j#{node[:cpu][:total]} && \
    make -j#{node[:cpu][:total]} install && \
    cd / && rm -rf /tmp/sphinx-#{node[:sphinx][:version]} /tmp/sphinx-#{node[:sphinx][:version]}.tar.gz
  EOH
  not_if { ::File.exist?('/usr/local/bin/searchd') }
end

