$ScriptStartTime = Get-Date
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
# Importer les modules nécessaires
Import-Module DHCPServer
Import-Module ActiveDirectory
Import-Module ImportExcel

# Définir les variables de serveur et de scope & fichier de stockage
$DHCPServer = Get-DhcpServerInDC | ForEach-Object { $_.DnsName } # Récupération automatique des serveurs DHCP
$ScopeId = @() # Liste des réseaux à exclure
$logDHCP = "$scriptpath\donnees.json" # données du DHCP, avec en plus le premiervu qui permet de de garder une trace même avec un bail expiré

# Timestamp commun pour les rapports + dossier Report
$ReportTimestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$ReportDir = Join-Path $scriptpath 'Report'
New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
$HTMLreport = Join-Path $ReportDir "dhcp_lease_report_$ReportTimestamp.html"
$ExcelReport = Join-Path $ReportDir "dhcp_lease_report_$ReportTimestamp.xlsx"
$templatePath = "$scriptpath\template.html"
$recipients = "$scriptpath\recipients_emails.json"

$UpdateEndpointLogs = @() # Initialiser la variable pour stocker les nouveaux appareils
$ExistingData = @() # Initialiser la variable pour stocker les données existantes
$TotalAppareilsScannes = 0

# Vérifier si le fichier de log existe déjà et le charger s'il existe
if (Test-Path $logDHCP) {
    $ExistingData = Get-Content $logDHCP | ConvertFrom-Json
}
else {
    # Si le fichier n'existe pas, créer un tableau vide
    $ExistingData = @()
}

Write-Host "1- Initialisation terminée." -ForegroundColor Green

########### FIN DE LA CONFIGURATION ###########