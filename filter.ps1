
# Supprimer les appareils qui sont maintenant dans l'AD
$ExistingData = $ExistingData | Where-Object {
    -not (Get-ADComputer -Filter "Name -eq '$($_.HostName)'" -Properties Name)
}

# Nettoyage des anciennes entrées si le scope est désormais exclu
$ExistingData = $ExistingData | Where-Object {
    $ip = [IPAddress]::Parse($_.IPAdresse)
    $keep = $true
    foreach ($excludedScope in $ScopeId) {
        try {
            $subnet = [IPAddress]::Parse($excludedScope)
            # On considère /24 donc masque 255.255.255.0
            $subnetBytes = $subnet.GetAddressBytes()
            $ipBytes = $ip.GetAddressBytes()
            $keep = $false
            for ($i = 0; $i -lt 3; $i++) {
                if ($ipBytes[$i] -ne $subnetBytes[$i]) {
                    $keep = $true
                    break
                }
            }
        }
        catch {
            $keep = $true # En cas d'erreur de conversion, on garde par sécurité
        }
        if (-not $keep) { break }
    }
    return $keep
}

# Nettoyer les appareils avec un bail expiré mais marqués comme actifs
$ExistingData = $ExistingData | ForEach-Object {
    if ($_.DHCPLeaseActif -eq "✅" -and [datetime]$_.LasttView -lt (Get-Date)) {
        $_.DHCPLeaseActif = "❌"
    }
    $_
}

# Ajout des nouveaux appareils et sauvegarde des données
$ExistingData += $UpdateEndpointLogs # Ajouter uniquement les nouveaux appareils à ExistingData sans les appareils présents dans AD
$ExistingData | ConvertTo-Json -Depth 3 | Out-File -Encoding utf8 -FilePath $logDHCP # Sauvegarder les données mises à jour dans le fichier JSON

# Filtrer les appareils actifs
$AppareilsActifs = $ExistingData | Where-Object {
    $_.DHCPLeaseActif -eq "✅"
} | Sort-Object { [datetime]$_.LasttView } -Descending

# Filtrer les appareils inactifs
$AppareilsInactives = $ExistingData | Where-Object {
    $_.DHCPLeaseActif -eq "❌"
} | Sort-Object { [datetime]$_.LasttView } -Descending

# Supprimer les appareils inactifs depuis plus de 90 jours
$AppareilsInactives = $AppareilsInactives | Where-Object {
    [datetime]$_.LasttView -ge (Get-Date).AddDays(-$InactivityThresholdDays)
}

Write-Host "3- Filtrage terminée." -ForegroundColor Green