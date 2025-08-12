# Génération du rapport Excel (onglets Actifs / Inactifs) via ImportExcel

# S’assurer que le dossier Report existe
New-Item -ItemType Directory -Path "$scriptpath\Report" -Force | Out-Null

# Préparer les données et l’ordre des colonnes
$cols = @('ScopeName','IPAdresse','HostName','MACAdresse','FirstView','LasttView')
$actifs   = $AppareilsActifs    | Select-Object $cols
$inactifs = $AppareilsInactives | Select-Object $cols

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
