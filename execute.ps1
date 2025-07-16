$scriptpath = ".\"

. "$scriptpath\initialisation.ps1"
. "$scriptpath\dhcp.ps1"
. "$scriptpath\filter.ps1"
. "$scriptpath\html.ps1"
. "$scriptpath\mail.ps1"


if (-not (Test-Path $scriptpath)) {
    Write-Error "Chemin introuvable : $scriptpath"
    exit 1
}
