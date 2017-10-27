Describe 'Windows features' {
  $features = @(
    @{feature = 'AD-Domain-Services'}
    @{feature = 'DNS'}
  )
  It "<feature> is enabled" -TestCases $features {
    param($feature)
    (Get-WindowsFeature -Name $feature).Installed | should be $true
  }
}

Describe 'Package providers' {
  $packageProvider = 'NuGet'
  It "$packageProvider is installed" {
    (Get-PackageProvider -Name $packageProvider).ProviderName | Should Be $packageProvider
  }
}

Describe 'Modules' {
  $modules = @(
    @{module = 'xActiveDirectory'}
    @{module = 'xNetworking'}
  )
  It "<module> is enabled" -TestCases $modules {
    param($module)
    (Get-Module -Name $module -List).Name | Should Be $module
  }
}

Describe 'DNS client' {
  $dnsAddress = '127.0.0.1'
  It "$dnsAddress is configured as DNS client server address for interface 'Ethernet 2'" {
    Get-DnsClientServerAddress -InterfaceAlias 'Ethernet 2' -AddressFamily ipv4 | Select-Object -ExpandProperty ServerAddresses | Should be $dnsAddress
  }
}

Describe 'Active Directory' {
  Context 'Forest' {
    $adForest = 'test-kitchen.local'
    It "$adForest exists" {
      (Get-ADForest).Name | Should Be $adForest
    }
  }
  Context 'Domain Controller' {
    $domainController = 'dc01.test-kitchen.local'
    It "$domainController is domain controller" {
      (Get-ADDomainController -Identity $domainController).HostName | Should Be $domainController
    }
  }

}
