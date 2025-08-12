# Lire le template HTML en UTF8
$HTMLTemplate = Get-Content $templatePath -Raw

# Générer les lignes de tableau HTML pour les appareils actifs
$TableRows = foreach ($Appareil in $AppareilsActifs) {
    "<tr>
    <td>$($Appareil.ScopeName.Trim())</td>
    <td>$($Appareil.IPAdresse.Trim())</td>
    <td>$($Appareil.HostName.Trim())</td>
    <td>$($Appareil.MACAdresse.Trim())</td>
    <td>$($Appareil.FirstView.Trim())</td>
    <td>$($Appareil.LasttView.Trim())</td>
    </tr>"
}

# Générer les lignes de tableau HTML pour les appareils inactifs
$InactiveTableRows = foreach ($Appareil in $AppareilsInactives) {
    "<tr>
    <td>$($Appareil.ScopeName.Trim())</td>
    <td>$($Appareil.IPAdresse.Trim())</td>
    <td>$($Appareil.HostName.Trim())</td>
    <td>$($Appareil.MACAdresse.Trim())</td>
    <td>$($Appareil.FirstView.Trim())</td>
    <td>$($Appareil.LasttView.Trim())</td>
    </tr>"
}

# Calculer la durée d'exécution du script
$ScriptEndTime = Get-Date
$ExecutionDuration = New-TimeSpan -Start $ScriptStartTime -End $ScriptEndTime
$ExecutionReadable = "$(($ExecutionDuration.Minutes)) min $(($ExecutionDuration.Seconds)) sec $(($ExecutionDuration.Milliseconds)) ms"

# Remplacer les balises dans le template
$HTMLFinal = $HTMLTemplate `
-replace '<!---DATE-->', $(Get-Date).ToString('yyyy-MM-dd HH:mm:ss') `
-replace '<!--TOTAL_HOSTS-->', $TotalAppareilsScannes `
-replace '<!--HOST_COUNT-->', $AppareilsActifs.Count `
-replace '<!--HOST_COUNT_INACTIVE-->', $AppareilsInactives.Count `
-replace '<!--DURATION-->', $ExecutionReadable `
-replace '<!--DATA_ROWS-->', $TableRows `
-replace '<!--DATA_ROWS_INACTIVES-->', $InactiveTableRows

# S'assurer que le dossier Report existe puis nettoyage des anciens fichiers
New-Item -ItemType Directory -Path "$scriptpath\Report" -Force | Out-Null
Remove-Item -Path "$scriptpath\Report\*" -Force -ErrorAction SilentlyContinue

# Écrire le fichier HTML final
$HTMLFinal | Out-File -FilePath $HTMLreport -Encoding utf8
Write-Host "4- Rapport HTML genere depuis le template : $HTMLreport" -ForegroundColor Green