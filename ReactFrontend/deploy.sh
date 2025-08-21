#!/bin/bash

echo "Starting React Frontend Deployment..."

# Update system
sudo apt update

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Apache2
sudo apt install apache2 -y

# Install Git
sudo apt install git -y

# Clone the project
git clone https://github.com/madhucm17/ReactFrontend.git
cd ReactFrontend

# Install dependencies
npm install

# Build the project
npm run build

# Create directory and move build files
sudo mkdir -p /var/www/reactproject
sudo cp -r build/* /var/www/reactproject/

# Configure Apache for port 8082
echo "Listen 8082" | sudo tee -a /etc/apache2/ports.conf

# Create Apache virtual host configuration
sudo tee /etc/apache2/sites-available/reactproject.conf > /dev/null <<EOF
<VirtualHost *:8082>
    DocumentRoot "/var/www/reactproject"
    <Directory "/var/www/reactproject">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Enable the site
sudo a2ensite reactproject.conf

# Restart Apache
sudo systemctl restart apache2

# Open firewall port
sudo ufw allow 8082

echo "Frontend deployment completed!"
echo "Access your React app at: http://13.126.226.179:8082"
