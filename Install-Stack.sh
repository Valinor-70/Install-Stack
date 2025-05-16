#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log_error()   { echo -e "${RED}[ERROR] $1${NC}"; }
log_success() { echo -e "${GREEN}[OK] $1${NC}"; }
log_info()    { echo -e "[INFO] $1"; }

# Ask for site name
read -rp "Enter your WordPress site domain (e.g. mysite.com): " DOMAIN
DOMAIN=${DOMAIN:-mysite.com}

# 1. Install dependencies
log_info "Installing required packages..."
sudo apt update && sudo apt install -y git curl wget ufw unzip mariadb-client nano || {
    log_error "Failed to install dependencies."; exit 1; }
log_success "Dependencies installed."

# 2. Install Webinoly
log_info "Installing Webinoly..."
wget -qO weby https://webinoly.com/install && sudo bash weby || {
    log_error "Webinoly installation failed."; exit 1; }
log_success "Webinoly installed."

# 3. Set up WordPress site
log_info "Creating WordPress site at $DOMAIN..."
sudo site "$DOMAIN" -wp || {
    log_error "Failed to create WordPress site."; exit 1; }
log_success "WordPress site created."

# 4. Install Crafty Control
log_info "Installing Crafty Control..."
git clone https://gitlab.com/crafty-controller/crafty-installer-4.0.git && \
cd crafty-installer-4.0 && \
sudo ./install_crafty.sh || {
    log_error "Crafty installation failed."; exit 1; }
log_success "Crafty Control installed."

# 5. Install rclone
log_info "Installing rclone..."
curl https://rclone.org/install.sh | sudo bash || {
    log_error "Failed to install rclone."; exit 1; }
log_success "rclone installed. You'll now need to run 'rclone config' to link your OneDrive."

# 6. Create backup script
BACKUP_SCRIPT="/usr/local/bin/backup-to-onedrive.sh"
log_info "Creating backup script..."
sudo tee "$BACKUP_SCRIPT" > /dev/null <<EOF
#!/bin/bash

BACKUP_DIR="/root/backups"
TIMESTAMP=\$(date +"%F_%H-%M")
SITE="$DOMAIN"
DB="wordpress"
CRAFTY_DIR="/opt/crafty"
NGINX_DIR="/etc/nginx"

mkdir -p "\$BACKUP_DIR"

tar -czf "\$BACKUP_DIR/wp-\${SITE}-\$TIMESTAMP.tar.gz" /var/www/\$SITE
mysqldump -u root \$DB > "\$BACKUP_DIR/\${DB}-\$TIMESTAMP.sql"
tar -czf "\$BACKUP_DIR/crafty-\$TIMESTAMP.tar.gz" \$CRAFTY_DIR \$NGINX_DIR

rclone copy "\$BACKUP_DIR" onedrive:ubuntu-backups --create-empty-src-dirs
find "\$BACKUP_DIR" -type f -mtime +7 -exec rm {} \;
EOF

sudo chmod +x "$BACKUP_SCRIPT" && \
log_success "Backup script created at $BACKUP_SCRIPT"

# 7. Schedule daily cron job
log_info "Scheduling daily backups at 2AM..."
(sudo crontab -l 2>/dev/null; echo "0 2 * * * $BACKUP_SCRIPT >> /var/log/backup.log 2>&1") | sudo crontab - && \
log_success "Cron job added."

echo -e "\n${GREEN}✅ Setup complete!${NC}"
echo "⚠️  Now run: ${GREEN}rclone config${NC}"
echo "    → Choose OneDrive"
echo "    → Name the remote: ${GREEN}onedrive${NC}"
echo "    → Confirm with: ${GREEN}rclone lsd onedrive:${NC}"
