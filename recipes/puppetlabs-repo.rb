#
# Cookbook Name:: mcollective
# Recipe:: puppetlabs-repo
#
# Installs the apt/yum repo for Puppetlabs packages.
#
# Copyright 2011, Zachary Stevens
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

case node['platform']
when "ubuntu","debian"
  apt_repository "puppetlabs" do
    uri "http://apt.puppetlabs.com/ubuntu"
    components ["lucid","main"]
    key "4BD6EC30"
    keyserver "pgp.mit.edu"
    action :add
  end

when "centos","redhat","fedora"
  yum_key "RPM-GPG-KEY-puppetlabs" do
    url "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs"
    action :add
  end
  
  yum_repository "puppetlabs" do
    name "puppetlabs"
    description "Puppet Labs Packages"
    url "http://yum.puppetlabs.com/base/"
    action :add
  end
end
