#
# Cookbook Name:: test_kitchen_adds
# Attributes:: default
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

node.default['test_kitchen_adds']['addomain']['database_path'] = 'C:\Windows\NTDS'
node.default['test_kitchen_adds']['addomain']['domain_administrator_username'] = 'Administrator'
node.default['test_kitchen_adds']['addomain']['domain_administrator_password'] = 'vagrant'
node.default['test_kitchen_adds']['addomain']['domain_name'] = 'test-kitchen.local'
node.default['test_kitchen_adds']['addomain']['log_path'] = 'C:\Windows\NTDS'
node.default['test_kitchen_adds']['addomain']['safemode_administrator_password'] = 'Testing123!'
node.default['test_kitchen_adds']['addomain']['sysvol_path'] = 'C:\Windows\SYSVOL'
