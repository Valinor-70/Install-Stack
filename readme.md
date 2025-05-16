# Install-Stack

Automated installer script for setting up:

- **Webinoly** (Nginx + WordPress)
- **Crafty Control** (game server manager)
- **Daily backups** of WordPress and Crafty to **OneDrive** using `rclone`

---

## Features

- Installs all dependencies required for the stack
- Sets up WordPress on your chosen domain via Webinoly
- Installs Crafty Control from the official installer repo
- Configures `rclone` for OneDrive backup synchronization
- Creates a backup script that archives your website files, WordPress database, and Crafty data daily
- Adds a cron job for automatic daily backups at 2 AM
- Automatically cleans up backups older than 7 days

---

## Requirements

- Ubuntu 20.04+ (ARM64 or x86_64)
- Root or sudo privileges
- A valid domain name pointing to your server (for WordPress)
- Internet connection
- OneDrive account for backups

---

## Usage

1. Download and run the installer script:

   ```bash
   sudo su
   curl -fsSL https://github.com/Valinor-70/Install-Stack/raw/refs/heads/main/Install-Stack.sh -o Install-Stack.sh
   chmod +x Install-Stack.sh
   ./Install-Stack.sh
