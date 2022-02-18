$subdominio =Read-Host "Introduce el dominio sin el sufijo: "
$dominio =Read-Host "Introduce el dominio sin el sufijo: "
$sufijo =Read-Host "Introduce el sufijo"

$dc="dc="+$subdominio+",dc="+$dominio+",dc="+$sufijo

if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}

$fichero_csv=Read-Host "Introduce el fichero para crear los grupos"

$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter :
			     
foreach($linea_leida in $fichero_csv_importado)
{

  

    $rutaContenedor =$linea_leida.Path+","+$dc
    $Name=$linea_leida.Name

    if (!(Get-ADGroup -filter { name -eq $Name })) {

        Write-Host $Name
        New-ADGroup -Name:$Name `
        -GroupCategory $linea_leida.Category `
        -GroupScope $linea_leida.Scope `
        -Path:$rutaContenedor

        Write-Host "Se ha cheado el grupo " + $Name
    
    }
}
pause
