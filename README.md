test_kitchen_adds cookbook
==========================
The test_kitchen_adds cookbook provides Active Directory domain controller and member helper recipes in Test Kitchen.

Requirements
------------
- Chef 12.x or higher
- Ruby 2.0 or higher (preferably from the Chef full-stack installer)
- Network accessible package repositories

Dependencies
------------
This cookbook depends on the following cookbooks.
- `hurry-up-and-test`

Platform Support
----------------
The following platforms have been tested with Test Kitchen:
- Windows Server 2016 Standard Server Core

Usage
-----
Include `test_kitchen_adds` as a dependency in your cookbook's `metadata.rb`.

```
 'test_kitchen_adds', '= 0.1.0'
```

.kitchen.yml
------------
Include a domain_controller suite in your cookbook to provide an Active Directory domain to join.  Use `kitchen converge` rather than `kitchen test` to avoid destroying the domain controller node before other suites are run.

Add the 'hurry-up-and-test::set_non_nat_vbox_ip' and 'test_kitchen_adds::join_domain' recipes to any suites which need to join to this domain.  The nodes provisioner is used to search for the domain controller IP in the join_domain recipe.

The .kitchen.yml settings below configure a private network interface for each node and manage chef-client exit codes on reboot.

```
---
driver:
  name: vagrant

provisioner:
  name: nodes
  client_rb:
    client_fork: false
    exit_status: :enabled
  retry_on_exit_code:
    - 35
  max_retries: 10
  wait_for_retry: 60

verifier:
  name: pester

platforms:
  - name: windows
    driver_config:
      box: jacqinthebox/windowsserver2016core
      network:
        - ["private_network", {type: "dhcp"}]
      customize:
        usb: 'off'

suites:
  - name: domain_controller
    driver:
      vm_hostname: dc01
    run_list:
      - hurry-up-and-test::set_non_nat_vbox_ip
      - test_kitchen_adds::domain_controller
  - name: domain_member
    run_list:
      - hurry-up-and-test::set_non_nat_vbox_ip
      - test_kitchen_adds::join_domain
```

Attributes
----------

The following attributes can be used to customise the Active Directory configuration.

```
node.default['test_kitchen_adds']['addomain']['database_path'] = 'C:\Windows\NTDS'
node.default['test_kitchen_adds']['addomain']['domain_administrator_username'] = 'Administrator'
node.default['test_kitchen_adds']['addomain']['domain_administrator_password'] = 'vagrant'
node.default['test_kitchen_adds']['addomain']['domain_name'] = 'test-kitchen.local'
node.default['test_kitchen_adds']['addomain']['log_path'] = 'C:\Windows\NTDS'
node.default['test_kitchen_adds']['addomain']['safemode_administrator_password'] = 'Testing123!'
node.default['test_kitchen_adds']['addomain']['sysvol_path'] = 'C:\Windows\SYSVOL'
```

Recipes
-------
#### `test_kitchen_adds::default`
Intentionally empty.
#### `test_kitchen_adds::domain_controller`
Configures Active Directory domain controller in Test Kitchen.
#### `test_kitchen_adds::join_domain`
Joins node to Active Directory domain in Test Kitchen.

Contributing
------------
1. Fork the repository on GitHub.
2. Create a named feature branch (like `add_component_x`).
3. Write your change.
4. Write tests for your change (this cookbook currently uses Pester with Test Kitchen).
5. Run the tests, ensuring they all pass.
6. Submit a Pull Request using GitHub.

License and Authors
-------------------
Author: Richard Lock

Copyright 2017 University of Derby

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
