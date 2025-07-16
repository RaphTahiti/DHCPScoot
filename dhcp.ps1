# Parcourir chaque serveur DHCP
foreach ($Server in $DHCPServer) {
    # Récupérer tous les scopes du serveur DHCP, sauf ceux spécifiés dans $ScopeId (qui est maintenant une liste d'exclusion)
    $AllScopes = Get-DhcpServerv4Scope -ComputerName $Server | Where-Object {
        $_.ScopeId.IPAddressToString -notin $ScopeId
    }

    # Parcourir chaque scope
    foreach ($ScopeObj in $AllScopes) {
        # Récupérer les baux DHCP pour le scope actuel
        $Scope = $ScopeObj.ScopeId.IPAddressToString
        $ScopeName = $ScopeObj.Name
        $DhcpBails = Get-DhcpServerv4Lease -ComputerName $Server -ScopeId $Scope

        # Vérifier si le bail est actif
        foreach ($Bail in $DhcpBails) {
            $TotalAppareilsScannes++ # Incrémenter le compteur d'appareils scannés

            # récupérations des informations
            $AdresseIp = $Bail.IPAddress.IPAddressToString
            $AdresseMac = $Bail.ClientId
            $HostName = if (![string]::IsNullOrWhiteSpace($Bail.HostName)) {
            $Bail.HostName.Split('.')[0]
            } else {
                "Null"
            }

            # Vérifier si l'appareil est présent dans l'AD
            $AppareilAD = Get-ADComputer -Filter { Name -eq $HostName } -Properties Name
            if ($AppareilAD) {
                continue
            }

            # Vérifier si l'appareil est déjà dans le fichier de log
            $AppareilExistant = $ExistingData | Where-Object { $_.HostName -eq $HostName }
            if ($AppareilExistant) {
                $AppareilExistant = $AppareilExistant[0]
            }

            # Si l'appareil n'existe pas dans le log, on l'ajoute
            if (-not $AppareilExistant) {
                $FirstView = if ($Bail.AllocatedAt) { $Bail.AllocatedAt.ToString('yyyy-MM-dd HH:mm:ss') } else { (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') }
                $DHCPLeaseActifBool = $Bail.LeaseExpiryTime -gt (Get-Date)
                $LasttViewDate = if ($DHCPLeaseActifBool) { $Bail.LeaseExpiryTime } else { Get-Date }

                # ajout des informations dans le json
                $UpdateEndpointLogs += [PSCustomObject]@{
                    IPAdresse      = $AdresseIp
                    HostName       = $HostName
                    MACAdresse     = $AdresseMac
                    FirstView      = $FirstView
                    LasttView      = $LasttViewDate.ToString('yyyy-MM-dd HH:mm:ss')
                    DHCPLeaseActif = if ($DHCPLeaseActifBool) { "✅" } else { "❌" }
                    ScopeName      = $ScopeName
                }

            } else {
                # Vérifier si l'appareil est maintenant dans l'AD (encore une fois ici, si c'est un ancien log)
                $AppareilAD = Get-ADComputer -Filter { Name -eq $HostName } -Properties Name
                if ($AppareilAD) {
                    continue
                }

                $AppareilExistant.IPAdresse = $AdresseIp

                # Si l'appareil n'a pas de FirstView, on le définit
                if (-not $AppareilExistant.FirstView) {
                    $AppareilExistant.FirstView = if ($Bail.AllocatedAt) { $Bail.AllocatedAt.ToString('yyyy-MM-dd HH:mm:ss') } else { (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') }
                }

                # Vérifier si le bail est actif
                $BailActif = $Bail.LeaseExpiryTime -gt (Get-Date)
                $AppareilExistant.DHCPLeaseActif = if ($BailActif) { "✅" } else { "❌" }

                # Mettre à jour LasttView uniquement si le bail est actif
                if ($BailActif) {
                    $AppareilExistant.LasttView = $Bail.LeaseExpiryTime.ToString('yyyy-MM-dd HH:mm:ss')
                    $AppareilExistant.ScopeName = $ScopeName
                } else {

                }
            }
        }
    }
}
Write-Host "2- Récupération des baux terminée." -ForegroundColor Green