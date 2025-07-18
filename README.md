# DHCPScoop

![PowerShell](https://img.shields.io/badge/PowerShell-0078d7?style=for-the-badge&logo=powershell&logoColor=white)  
![Platform](https://img.shields.io/badge/Platform-Windows%20Server-blue?style=for-the-badge)  
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)  
![License](https://img.shields.io/badge/License-Private-lightgrey?style=for-the-badge)

---

# 🇫🇷 Français

## 📌 Description

**DHCPScoop** est un outil PowerShell destiné aux administrateurs systèmes pour détecter les appareils connectés à un réseau informatique sans autorisation. Il génère un rapport clair des postes présents mais absents de l'inventaire ou non conformes aux règles d’accès.

---

### 🎯 Contexte

Dans un environnement professionnel sans **NAC** (*Network Access Control*), nous avons identifié la présence de machines externes sur le réseau. DHCPScoop est une initiative pour obtenir rapidement un état des lieux fiable des terminaux actifs sans déploiement complexe.

---

## ⚙️ Technologies

- PowerShell

---

## ✅ Prérequis

- Serveur **DHCP** sous Windows Server  
- Annuaire **Active Directory** Windows  
- Compte avec droits **lecture seule** sur le serveur DHCP et l’AD  
- **PowerShell 5.1 ou plus récent**

---

## 🚀 Installation & Exécution

### 1. Téléchargement
Récupérez le script depuis le dépôt Git.  

### 2. Préparation de l'environnement
Ouvrez **PowerShell en mode administrateur**.  
Si nécessaire, autorisez l'exécution des scripts :  
```
Set-ExecutionPolicy RemoteSigned -Scope Process
```

### 3. Configuration
Personnalisez l’exécution avec des paramètres dans les fichiers `initialisation.ps1` et `mail.ps1`.  
Personnalisez les destinataires dans `recipients_emails.json`.

### 4. Exécution du script
Lancez simplement :  
```
.\execute.ps1
```

### 5. Automatisation (optionnelle)
Pour un suivi régulier, créez une **tâche planifiée Windows** qui exécute :  
"""
programme : C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
argument : -Command "& chemin\vers\execute.ps1"
"""

---

## 👤 Auteur

- **Raphaël**

---

# 🇬🇧 English

## 📌 Description

**DHCPScoop** is a PowerShell tool designed for system administrators to detect unauthorized devices connected to a corporate network. It generates a clear report of hosts that are present but missing from the inventory or non-compliant with access rules.

---

### 🎯 Context

In a professional environment without **NAC** (*Network Access Control*), we identified the presence of external machines on the network. DHCPScoop is an initiative to quickly obtain a reliable overview of active endpoints without complex deployment.

---

## ⚙️ Technologies

- PowerShell

---

## ✅ Requirements

- **DHCP** server running on Windows Server  
- Windows **Active Directory**  
- Account with **read-only** rights on the DHCP server and AD  
- **PowerShell 5.1 or later**

---

## 🚀 Installation & Execution

### 1. Download
Get the script from the Git repository.  

### 2. Environment Setup
Open **PowerShell as Administrator**.  
If needed, allow script execution:  
```
Set-ExecutionPolicy RemoteSigned -Scope Process
```

### 3. Configuration
Customize the execution parameters in `initialisation.ps1` and `mail.ps1`.  
Set the recipients in `recipients_emails.json`.

### 4. Run the Script
Simply execute:  
```
.\execute.ps1
```

### 5. Automation (Optional)
For regular monitoring, create a **Windows Scheduled Task** to run:  
"""
program : C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
argument : -Command "& path\to\execute.ps1"
"""

---

## 👤 Author

- **Raphaël**
