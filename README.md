# BlogHub - Professional Blog Platform

A modern, full-stack blog platform built with React.js, Node.js, and MySQL. Features user authentication, blog post creation, comments, admin panel, and more.

## Features

- **User Authentication**: Register, login, and profile management
- **Blog Posts**: Create, edit, and publish blog posts with rich text editor
- **Image Upload**: Upload featured images for blog posts
- **Comments System**: Add comments and replies to posts
- **Admin Panel**: Manage users, posts, and comments
- **Responsive Design**: Modern UI/UX that works on all devices
- **Search Functionality**: Search posts by title and content
- **Like System**: Like and unlike posts
- **User Profiles**: View user profiles and their posts

## Tech Stack

### Frontend
- React.js 18
- React Router DOM
- Tailwind CSS
- React Hook Form
- React Hot Toast
- Lucide React Icons
- React Quill (Rich Text Editor)

### Backend
- Node.js
- Express.js
- MySQL (RDS)
- JWT Authentication
- Multer (File Upload)
- bcryptjs (Password Hashing)
- Express Validator

### Deployment
- AWS EC2
- Apache2
- PM2 (Process Manager)
- AWS RDS (MySQL)

## Prerequisites

- Node.js 16+ and npm
- MySQL 8.0+
- Apache2 (for production)
- PM2 (for production)

## Installation

### 1. Clone the repository
```bash
git clone <repository-url>
cd professional-blog-website
```

### 2. Install backend dependencies
```bash
npm install
```

### 3. Install frontend dependencies
```bash
cd client
npm install
cd ..
```

### 4. Environment Configuration
Create a `.env` file in the root directory:
```bash
cp env.example .env
```

Update the `.env` file with your configuration:
```env
# Server Configuration
PORT=5000
NODE_ENV=production

# Database Configuration (RDS)
DB_HOST=your-rds-endpoint.amazonaws.com
DB_USER=your_db_username
DB_PASSWORD=your_db_password
DB_NAME=blog_db
DB_PORT=3306

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production

# Frontend URL (for CORS)
FRONTEND_URL=http://13.126.226.179
```

### 5. Database Setup
The application will automatically create the database and tables on first run. Make sure your MySQL server is running and accessible.

## Development

### Start Backend Server
```bash
npm run dev
```

### Start Frontend Development Server
```bash
cd client
npm start
```

The application will be available at:
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000

## Production Deployment

### 1. Build Frontend
```bash
cd client
npm run build
cd ..
```

### 2. Configure Apache2
Copy the Apache configuration:
```bash
sudo cp apache2.conf /etc/apache2/sites-available/blog.conf
sudo a2ensite blog
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo a2enmod headers
sudo systemctl restart apache2
```

### 3. Deploy Frontend
```bash
sudo cp -r client/build/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
```

### 4. Start Backend with PM2
```bash
npm install -g pm2
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

### 5. Configure Firewall
```bash
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 22
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user
- `PUT /api/auth/profile` - Update profile

### Posts
- `GET /api/posts` - Get all published posts
- `GET /api/posts/:id` - Get single post
- `POST /api/posts` - Create new post
- `PUT /api/posts/:id` - Update post
- `DELETE /api/posts/:id` - Delete post
- `POST /api/posts/:id/like` - Like/unlike post

### Comments
- `GET /api/comments/post/:postId` - Get comments for post
- `POST /api/comments` - Add comment
- `PUT /api/comments/:id` - Update comment
- `DELETE /api/comments/:id` - Delete comment

### Users
- `GET /api/users/:username` - Get user profile
- `GET /api/users/:username/posts` - Get user's posts
- `PUT /api/users/profile` - Update user profile

### Admin (Admin only)
- `GET /api/admin/dashboard` - Admin dashboard stats
- `GET /api/admin/users` - Get all users
- `PUT /api/admin/users/:id/role` - Update user role
- `DELETE /api/admin/users/:id` - Delete user
- `GET /api/admin/posts` - Get all posts
- `PUT /api/admin/posts/:id/status` - Update post status
- `DELETE /api/admin/posts/:id` - Delete post
- `GET /api/admin/comments` - Get all comments
- `DELETE /api/admin/comments/:id` - Delete comment

## Default Admin Account

The application creates a default admin account on first run:
- Email: admin@blog.com
- Password: admin123

**Important**: Change the default admin password after first login!

## File Structure

```
├── client/                 # React frontend
│   ├── public/
│   ├── src/
│   │   ├── components/     # Reusable components
│   │   ├── contexts/       # React contexts
│   │   ├── pages/          # Page components
│   │   └── ...
│   └── package.json
├── config/                 # Database configuration
├── middleware/             # Express middleware
├── routes/                 # API routes
├── uploads/                # Uploaded files
├── server.js              # Main server file
├── package.json
└── README.md
```

## Security Features

- JWT-based authentication
- Password hashing with bcrypt
- Input validation and sanitization
- CORS configuration
- Rate limiting
- Security headers
- File upload restrictions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please open an issue on GitHub.

## Deployment Notes

- The application is configured to run on AWS EC2 with your IP: 13.126.226.179
- Make sure to update the CORS settings in `server.js` if you change the domain
- The frontend proxy is configured to point to your EC2 IP
- All API calls use relative paths to work with the Apache proxy setup
