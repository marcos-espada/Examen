$subdominio =Read-Host "Introduce el subdominio: "
$dominio =Read-Host "Introduce el dominio sin el sufijo: "
$sufijo =Read-Host "Introduce el sufijo"


$dc="dc="+$subdominio+",dc="+$dominio+",dc="+$sufijo


Import-Module ActiveDirectory #Se carga el módulo


$fichero_csv=Read-Host "Introduce el fichero csv de los Equipos:"

$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea_leida in $fichero_csv_importado)
{
  $rutaContenedor =$linea_leida.Path+","+$dc

  $Name = $linea_leida.Name | Out-String -Stream

  New-ADComputer -Enabled:$true -Name:$Name -Path:$rutaContenedor -SamAccountName:$linea_leida.Name

}
pause
