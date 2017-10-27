name 'test_kitchen_adds'
maintainer 'University of Derby'
maintainer_email 'its-chef@derby.ac.uk'
license 'Apache-2.0'
description 'The test_kitchen_adds cookbook provides Active Directory domain controller and member helper recipes in test kitchen.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
source_url 'https://github.com/universityofderby/chef-test_kitchen_adds'
issues_url 'https://github.com/universityofderby/chef-test_kitchen_adds/issues'
chef_version '>= 12.0'
supports 'windows'

depends 'hurry-up-and-test', '~> 0.1.2'
