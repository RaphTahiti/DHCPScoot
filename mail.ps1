# SMTP Configuration
$SMTPServer = ""
$SMTPPort = 587
$SMTPFrom = ""

# Sujet de l’email
$EmailSubject = "[DHCPScoot] Rapport des Baux DHCP - $(Get-Date -Format 'yyyy-MM-dd')"

# Récupération de la liste des destinataires depuis un fichier JSON
$emailList = Get-Content $recipients | ConvertFrom-Json
$SMTPRecipients = $emailList.recipients #-join ','


# Corps HTML du mail
$HTMLBody = $HTMLFinal  # Assure-toi que $HTMLFinal contient du HTML valide

# Envoi de l’e-mail
try {
    Send-MailMessage -From $SMTPFrom `
                     -To $SMTPRecipients `
                     -Subject $EmailSubject `
                     -Body $HTMLBody `
                     -BodyAsHtml `
                     -SmtpServer $SMTPServer `
                     -Port $SMTPPort 
    Write-Host "5- Email envoyé avec succès." -ForegroundColor Green
}
catch {
    Write-Host "5- Erreur lors de l'envoi : $($_.Exception.Message)" -ForegroundColor Red
}