$subdominio =Read-Host "Introduce el subdominio: "
$dominio =Read-Host "Introduce el dominio sin el sufijo: "
$sufijo =Read-Host "Introduce el sufijo"

$dc="dc="+$subdominio+",dc="+$dominio+",dc="+$sufijo

if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}


$fichero_csv=Read-Host "Introduce el fichero csv de los usuarios:"


$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea_leida in $fichero_csv_importado)
{
  	$rutaContenedor =$linea_leida.Path+","+$dc 
	
  	$passAccount=ConvertTo-SecureString $linea_leida.Dni -AsPlainText -force
	
	$name=$linea_leida.Name
	$nameShort=$linea_leida.Name+'.'+$linea_leida.Surname1
	$Surnames=$linea_leida.Surname1+' '+$linea_leida.Surname2
	$nameLarge=$linea_leida.Name+' '+$linea_leida.Surname1+' '+$linea_leida.Surname2
  
  
	if (Get-ADUser -filter { name -eq $nameShort })
	{
		$nameShort=$linea_leida.Name+'.'+$linea_leida.Surname1+"."+$linea_leida.Surname2
	}
	
	[boolean]$Habilitado=$true
  	If($linea_leida.Enabled -Match 'false') { $Habilitado=$false}
  
  	$ExpirationAccount = $linea_leida.TurnPassDays
 	$timeExp = (get-date).AddDays($ExpirationAccount)
	
	Write-Host "Name: "+ $nameShort + "ruta: " + $rutaContenedor

	New-ADUser `
    		-SamAccountName $nameShort `
   	 	    -UserPrincipalName $nameShort `
    		-Name $nameShort `
		    -Surname $Surnames `
    		-DisplayName $nameLarge `
    		-GivenName $name `
    		-LogonWorkstations:$linea_leida.Computer `
		    -Description "Cuenta de $nameLarge" `
    		-EmailAddress $linea_leida.email `
		    -AccountPassword $passAccount `
    		-Enabled $Habilitado `
			-Department $linea_leida.Department `
			-Organization $linea_leida.Delegation `
		    -CannotChangePassword $false `
    		-ChangePasswordAtLogon $true `
		    -PasswordNotRequired $false `
    		-Path $rutaContenedor `
    		-AccountExpirationDate $timeExp `
		    
	
  		foreach($group in $linea_leida.Groups.Split(",")){
			
			Add-ADGroupMember -Identity $group -Members $nameShort

		  }
        
	
	
	Import-Module .\SetADUserLogonTime.psm1
	Set-OSCLogonHours -SamAccountName $nameShort -DayofWeek Monday,Tuesday,Wednesday,Thursday,Friday -From $linea_leida.ScheduleFrom -To $linea_leida.ScheduleTo
}
pause
