# Génération du rapport Excel (onglets Actifs / Inactifs) via ImportExcel

# S’assurer que le dossier Report existe
New-Item -ItemType Directory -Path "$scriptpath\Report" -Force | Out-Null


# Vérification du module ImportExcel
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Write-Host "ERREUR : Le module ImportExcel n'est pas installé !" -ForegroundColor Red
    return
}

# Vérification des données
if (-not $AppareilsActifs -or $AppareilsActifs.Count -eq 0) {
    Write-Host "ERREUR : Aucun appareil actif trouvé !" -ForegroundColor Red
}
if (-not $AppareilsInactives -or $AppareilsInactives.Count -eq 0) {
    Write-Host "ERREUR : Aucun appareil inactif trouvé !" -ForegroundColor Red
}


# Sélection avec noms français (syntaxe compatible PowerShell)
$actifs = $AppareilsActifs | Select-Object `
    @{Name='Etendue';Expression={$_.ScopeName}},
    @{Name='Adresse IP';Expression={$_.IPAdresse}},
    @{Name="Nom de l'hote";Expression={$_.HostName}},
    @{Name='Adresse MAC';Expression={$_.MACAdresse}},
    @{Name='Premiere detection';Expression={$_.FirstView}},
    @{Name='Debut du bail DHCP';Expression={$_.ArriveeReseau}},
    @{Name='Fin du bail DHCP';Expression={$_.LasttView}}

$inactifs = $AppareilsInactives | Select-Object `
    @{Name='Etendue';Expression={$_.ScopeName}},
    @{Name='Adresse IP';Expression={$_.IPAdresse}},
    @{Name="Nom de l'hote";Expression={$_.HostName}},
    @{Name='Adresse MAC';Expression={$_.MACAdresse}},
    @{Name='Premiere detection';Expression={$_.FirstView}},
    @{Name='Debut du bail DHCP';Expression={$_.ArriveeReseau}},
    @{Name='Fin du bail DHCP';Expression={$_.LasttView}}

try {
    # Feuille Actifs
    $actifs | Export-Excel -Path $ExcelReport `
                           -WorksheetName 'Actifs' `
                           -TableName 'Actifs' `
                           -AutoSize -BoldTopRow -FreezeTopRow -AutoFilter `
                           -TableStyle 'Medium2'

    # Feuille Inactifs (append)
    $inactifs | Export-Excel -Path $ExcelReport `
                             -WorksheetName 'Inactifs' `
                             -TableName 'Inactifs' `
                             -AutoSize -BoldTopRow -FreezeTopRow -AutoFilter `
                             -TableStyle 'Medium2' `
                             -Append

    Write-Host "5- Rapport Excel généré : $ExcelReport" -ForegroundColor Green
}
catch {
    Write-Host "5- Erreur lors de la génération Excel : $($_.Exception.Message)" -ForegroundColor Red
}
