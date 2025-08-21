# Blog Frontend

React.js frontend for the professional blog website.

## Features

- Modern, responsive UI with Tailwind CSS
- User authentication and profile management
- Blog post creation and management
- Comment system with replies
- Admin panel for content management
- Rich text editor for blog posts
- Search and filtering functionality

## Tech Stack

- React.js
- React Router DOM
- Tailwind CSS
- React Hook Form
- React Hot Toast
- Lucide React (icons)
- React Quill (rich text editor)
- Axios for API calls

## Installation

1. Clone the repository:
```bash
git clone https://github.com/madhucm17/ReactFrontend.git
cd ReactFrontend
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm start
```

The app will be available at `http://localhost:3000`

## Build for Production

```bash
npm run build
```

## Deployment

### Manual Deployment
```bash
chmod +x deploy.sh
./deploy.sh
```

### Apache Configuration
The project includes Apache configuration for deployment on port 8082.

### Jenkins CI/CD
The project includes a Jenkinsfile for automated deployment.

## Project Structure

```
src/
├── components/          # Reusable components
│   ├── auth/           # Authentication components
│   ├── common/         # Common UI components
│   ├── layout/         # Layout components
│   └── posts/          # Post-related components
├── contexts/           # React contexts
├── pages/              # Page components
└── utils/              # Utility functions
```

## API Integration

The frontend communicates with the backend API running on port 8081. Make sure the backend is running before using the frontend.

## Default Admin Account

- Email: admin@blog.com
- Password: admin123
