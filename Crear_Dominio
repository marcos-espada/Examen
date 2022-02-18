Install-WindowsFeature -name AD-Domain-Services,DNS -IncludeManagementTools 
$dominioFQDN = "LAUDESchool.org"
$dominioNETBIOS = "LAUDESCHOOL"
$adminPass = "Sv21nc-4e"
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$False `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName $dominioFQDN `
-DomainNetbiosName $dominioNETBIOS `
-SafeModeAdministratorPassword (ConvertTo-SecureString -string $adminPass -AsPlainText -Force)`
-ForestMode "WinThreshold" `
-InstallDns:$True `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$False `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true 
