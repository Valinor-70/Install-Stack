# 🚀 Install-Stack

> **Made this script for Oracle Cloud users — their deleting accounts for no was a pain to setup again!** 😢  
> **Remember:** You might want to run commands as root:  
> ```bash
> sudo su
> ```

---

## 🎯 What is this?

Automated installer script to set up:

- 🕸️ **Webinoly** (Nginx + WordPress)  
- 🎮 **Crafty Control** (game server manager)  
- ☁️ **Daily backups** of WordPress + Crafty to **OneDrive** using `rclone`

---

## 🌟 Features

- ✅ Installs all dependencies for the full stack  
- ✅ Sets up WordPress on your domain with Webinoly  
- ✅ Installs Crafty Control from official sources  
- ✅ Configures `rclone` for OneDrive backups  
- ✅ Creates daily backup script for website files, DB, and Crafty data  
- ✅ Schedules cron job to run backups daily at 2 AM  
- ✅ Cleans up backups older than 7 days automatically

---

## 📋 Requirements

| Requirement         | Details                           |
|---------------------|---------------------------------|
| OS                  | Ubuntu 20.04+ (ARM64 or x86_64) |
| Privileges          | Root or sudo                    |
| Domain              | Valid domain pointing to server |
| Internet Connection | Required                        |
| OneDrive Account    | For backups                    |

---

## ⚙️ Usage

1. **Download & run the installer script:**

   ```bash
   curl -fsSL https://github.com/Valinor-70/Install-Stack/raw/refs/heads/main/Install-Stack.sh -o Install-Stack.sh
   chmod +x Install-Stack.sh
   ./Install-Stack.sh
