Describe 'Computer' {
  $adDomain = 'test-kitchen.local'
  It "Is joined to domain $adDomain" {
    (Get-WmiObject -Class Win32_ComputerSystem).Domain | Should Be $adDomain
  }
}
