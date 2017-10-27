#
# Cookbook Name:: test_kitchen_adds
# Recipe:: join_domain
#
# Copyright 2017, University of Derby
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

require 'timeout'

def search_for_nodes(query, timeout = 120) # rubocop:disable Metrics/MethodLength
  nodes = []
  Timeout.timeout(timeout) do
    nodes = search(:node, query)
    until nodes.count > 0 && nodes[0].key?('ipaddress')
      sleep 5
      nodes = search(:node, query)
    end
  end

  if nodes.count.zero? || !nodes[0].key?('ipaddress')
    raise 'Unable to find nodes!'
  end

  nodes
end

domain_controller = search_for_nodes('run_list:*test_kitchen_adds??domain_controller*')

# Install package provider NuGet
powershell_script 'Install-PackageProvider_NuGet' do
  code 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force'
  not_if '(Get-PackageProvider -Name NuGet -ListAvailable) -ne $null'
end

# Install DSC modules xComputerManagement and xNetworking
%w[xActiveDirectory xComputerManagement xNetworking].each do |m|
  powershell_script "Install-Module_#{m}" do
    code "Install-Module -Name #{m} -Force"
    not_if "(Get-Module -Name #{m} -ListAvailable) -ne $null"
  end
end

# Configure DNS server address
dsc_resource 'xDnsServerAddress' do
  resource :xDnsServerAddress
  property :Address, [domain_controller[0]['ipaddress']]
  property :AddressFamily, 'IPv4'
  property :InterfaceAlias, 'Ethernet 2'
end

# Wait for AD domain
dsc_resource 'xWaitForADDomain' do
  resource :xWaitForADDomain
  property :DomainName, node['test_kitchen_adds']['addomain']['domain_name']
  property :DomainUserCredential, ps_credential(
    node['test_kitchen_adds']['addomain']['domain_administrator_username'],
    node['test_kitchen_adds']['addomain']['domain_administrator_password']
  )
  property :RetryCount, 20
  property :RetryIntervalSec, 30
end

# Join domain
dsc_resource 'xComputer_joindomain' do
  resource :xComputer
  property :DependsOn, ['[xWaitForADDomain]xWaitForADDomain']
  property :DomainName, node['test_kitchen_adds']['addomain']['domain_name']
  property :Credential, ps_credential(
    "#{node['test_kitchen_adds']['addomain']['domain_name']}\\#{node['test_kitchen_adds']['addomain']['domain_administrator_username']}",
    node['test_kitchen_adds']['addomain']['domain_administrator_password']
  )
  property :Name, node['hostname']
  reboot_action :request_reboot
end
