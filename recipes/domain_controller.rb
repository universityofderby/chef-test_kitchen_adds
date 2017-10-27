#
# Cookbook Name:: test_kitchen_adds
# Recipe:: domain_controller
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

# Install Windows features DNS Server, and AD Domain Services
%w[DNS AD-Domain-Services].each do |f|
  dsc_resource "WindowsFeature_#{f}" do
    resource :WindowsFeature
    property :Ensure, 'Present'
    property :Name, f
  end
end

# Install package provider NuGet
powershell_script 'Install-PackageProvider_NuGet' do
  code 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force'
  not_if '(Get-PackageProvider -Name NuGet -ListAvailable) -ne $null'
end

# Install DSC modules xActiveDirectory and xNetworking
%w[xActiveDirectory xNetworking].each do |m|
  powershell_script "Install-Module_#{m}" do
    code "Install-Module -Name #{m} -Force"
    not_if "(Get-Module -Name #{m} -ListAvailable) -ne $null"
  end
end

# Configure loopback for DNS server address
dsc_resource 'xDnsServerAddress_loopback' do
  resource :xDnsServerAddress
  property :Address, ['127.0.0.1']
  property :AddressFamily, 'IPv4'
  property :DependsOn, ['[WindowsFeature]DNS']
  property :InterfaceAlias, 'Ethernet 2'
end

# Configure AD forest
dsc_resource 'xADDomain_forest' do
  resource :xADDomain
  property :DatabasePath, node['test_kitchen_adds']['addomain']['database_path']
  property :DependsOn, ['[WindowsFeature]windowsfeature_AD-Domain-Services']
  property :DomainAdministratorCredential, ps_credential(
    node['test_kitchen_adds']['addomain']['domain_administrator_username'],
    node['test_kitchen_adds']['addomain']['domain_administrator_password']
  )
  property :DomainName, node['test_kitchen_adds']['addomain']['domain_name']
  property :LogPath, node['test_kitchen_adds']['addomain']['log_path']
  property :SafeModeAdministratorPassword, ps_credential(
    node['test_kitchen_adds']['addomain']['safemode_administrator_password']
  )
  property :Sysvolpath, node['test_kitchen_adds']['addomain']['sysvol_path']
  reboot_action :reboot_now
end
