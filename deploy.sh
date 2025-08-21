#!/bin/bash

# BlogHub Deployment Script for AWS EC2
# This script automates the deployment process

set -e

echo "🚀 Starting BlogHub deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Node.js and npm
print_status "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install MySQL client
print_status "Installing MySQL client..."
sudo apt install -y mysql-client

# Install Apache2
print_status "Installing Apache2..."
sudo apt install -y apache2

# Install PM2 globally
print_status "Installing PM2..."
sudo npm install -g pm2

# Enable Apache modules
print_status "Enabling Apache modules..."
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo a2enmod headers

# Install backend dependencies
print_status "Installing backend dependencies..."
npm install

# Install frontend dependencies
print_status "Installing frontend dependencies..."
cd client
npm install
cd ..

# Build frontend
print_status "Building frontend..."
cd client
npm run build
cd ..

# Configure Apache
print_status "Configuring Apache..."
sudo cp apache2.conf /etc/apache2/sites-available/blog.conf
sudo a2ensite blog
sudo a2dissite 000-default.conf

# Deploy frontend
print_status "Deploying frontend..."
sudo rm -rf /var/www/html/*
sudo cp -r client/build/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/

# Create uploads directory
print_status "Creating uploads directory..."
sudo mkdir -p /var/www/uploads
sudo chown -R www-data:www-data /var/www/uploads

# Configure firewall
print_status "Configuring firewall..."
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 22
sudo ufw --force enable

# Start backend with PM2
print_status "Starting backend with PM2..."
pm2 start ecosystem.config.js
pm2 save
pm2 startup

# Restart Apache
print_status "Restarting Apache..."
sudo systemctl restart apache2

# Create environment file if it doesn't exist
if [ ! -f .env ]; then
    print_warning "Creating .env file from template..."
    cp env.example .env
    print_warning "Please update the .env file with your database credentials and other settings!"
fi

# Check if .env file exists and has required variables
if [ -f .env ]; then
    print_status "Checking environment configuration..."
    
    # Check for required variables
    required_vars=("DB_HOST" "DB_USER" "DB_PASSWORD" "JWT_SECRET")
    missing_vars=()
    
    for var in "${required_vars[@]}"; do
        if ! grep -q "^${var}=" .env; then
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -ne 0 ]; then
        print_warning "Missing required environment variables: ${missing_vars[*]}"
        print_warning "Please update your .env file with the required values."
    else
        print_status "Environment configuration looks good!"
    fi
else
    print_error ".env file not found! Please create it from env.example"
fi

# Test database connection
print_status "Testing database connection..."
if node -e "
const db = require('./config/database');
db.getConnection((err, connection) => {
  if (err) {
    console.error('Database connection failed:', err.message);
    process.exit(1);
  }
  console.log('Database connected successfully');
  connection.release();
  process.exit(0);
});
" 2>/dev/null; then
    print_status "Database connection successful!"
else
    print_warning "Database connection failed. Please check your .env configuration."
fi

# Final status check
print_status "Checking service status..."
echo ""
echo "=== Service Status ==="
echo "Apache2: $(sudo systemctl is-active apache2)"
echo "PM2: $(pm2 status | grep blog-backend | awk '{print $10}')"
echo ""

# Display access information
echo "=== Access Information ==="
echo "🌐 Website: http://13.126.226.179"
echo "🔧 Admin Panel: http://13.126.226.179/admin"
echo "📧 Default Admin: admin@blog.com / admin123"
echo ""

print_status "Deployment completed successfully!"
print_warning "Don't forget to:"
print_warning "1. Update your .env file with proper database credentials"
print_warning "2. Change the default admin password"
print_warning "3. Configure your RDS security groups to allow connections from this EC2 instance"
print_warning "4. Set up SSL certificate for HTTPS (recommended)"

echo ""
print_status "🎉 BlogHub is now running on your EC2 instance!"
