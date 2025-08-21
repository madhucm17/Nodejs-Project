import React from 'react';
import { Link } from 'react-router-dom';
import { format } from 'date-fns';
import { 
  Eye, 
  Heart, 
  MessageCircle, 
  User, 
  Calendar 
} from 'lucide-react';

const PostCard = ({ post }) => {
  const truncateText = (text, maxLength = 150) => {
    if (text.length <= maxLength) return text;
    return text.substr(0, maxLength) + '...';
  };

  return (
    <article className="card-hover group">
      {/* Featured Image */}
      {post.featured_image && (
        <div className="mb-4 overflow-hidden rounded-lg">
          <img
            src={post.featured_image}
            alt={post.title}
            className="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
          />
        </div>
      )}

      {/* Content */}
      <div className="space-y-3">
        {/* Title */}
        <Link to={`/post/${post.id}`}>
          <h2 className="text-xl font-bold text-gray-900 group-hover:text-primary-600 transition-colors line-clamp-2">
            {post.title}
          </h2>
        </Link>

        {/* Excerpt */}
        {post.excerpt && (
          <p className="text-gray-600 line-clamp-3">
            {truncateText(post.excerpt)}
          </p>
        )}

        {/* Author and Date */}
        <div className="flex items-center space-x-3 text-sm text-gray-500">
          <div className="flex items-center space-x-1">
            {post.avatar ? (
              <img
                src={post.avatar}
                alt={post.full_name}
                className="w-5 h-5 rounded-full object-cover"
              />
            ) : (
              <User className="w-4 h-4" />
            )}
            <Link 
              to={`/user/${post.username}`}
              className="hover:text-primary-600 transition-colors"
            >
              {post.full_name}
            </Link>
          </div>
          <div className="flex items-center space-x-1">
            <Calendar className="w-4 h-4" />
            <span>{format(new Date(post.created_at), 'MMM d, yyyy')}</span>
          </div>
        </div>

        {/* Stats */}
        <div className="flex items-center space-x-4 text-sm text-gray-500 pt-2 border-t border-gray-100">
          <div className="flex items-center space-x-1">
            <Eye className="w-4 h-4" />
            <span>{post.views || 0}</span>
          </div>
          <div className="flex items-center space-x-1">
            <Heart className="w-4 h-4" />
            <span>{post.likes || 0}</span>
          </div>
          <div className="flex items-center space-x-1">
            <MessageCircle className="w-4 h-4" />
            <span>{post.comment_count || 0}</span>
          </div>
        </div>
      </div>
    </article>
  );
};

export default PostCard;
