#Primero instalamos AD y DNS
Install-WindowsFeature –Name AD-Domain-Services –IncludeManagementTools


#Creamos el subdominio
Import-Module ADDSDeployment
Install-ADDSDomain `
-NoGlobalCatalog:$false `
-CreateDnsDelegation:$true `
-Credential (Get-Credential) `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Default" `
-DomainType "ChildDomain" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NewDomainName "IESCamp" `
-NewDomainNetbiosName "IESCAMP" `
-ParentDomainName "edu-gva.es" `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
