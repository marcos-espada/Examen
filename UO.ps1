$subdominio =Read-Host "Introduce de el subdominio"
$dominio =Read-Host "Introduce el dominio sin el sufijo"
$sufijo =Read-Host "Introduce el sufijo"


$dc="dc="+$subdominio+",dc="+$dominio+",dc="+$sufijo


if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}

$fichero_csv=Read-Host "Introduce el fichero csv de las UO:"

$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea_leida in $fichero_csv_importado)
{
  $rutaContenedor=$dc
  if($linea_leida.Path -ne ""){$rutaContenedor =$linea_leida.Path+","+$dc}
  
  Write-Host $linea_leida.Name
  Write-Host $rutaContenedor
  New-ADOrganizationalUnit -Name:$linea_leida.Name -Path:$rutaContenedor

}
pause
