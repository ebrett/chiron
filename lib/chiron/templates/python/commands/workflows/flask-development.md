# Flask Development Workflow

Comprehensive guide for developing Flask applications with best practices and modern patterns.

## Project Setup

### Basic Flask Application Structure
```
myapp/
├── app/
│   ├── __init__.py          # Application factory
│   ├── models/              # Database models
│   ├── views/              # Route handlers
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   └── main.py
│   ├── templates/          # Jinja2 templates
│   ├── static/             # CSS, JS, images
│   └── utils/              # Helper functions
├── migrations/             # Database migrations
├── tests/                  # Test files
├── config.py              # Configuration
├── requirements.txt       # Dependencies
└── run.py                 # Application entry point
```

### Application Factory Pattern
```python
# app/__init__.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager
import os

db = SQLAlchemy()
migrate = Migrate()
login_manager = LoginManager()

def create_app(config_class=None):
    app = Flask(__name__)
    
    # Configuration
    if config_class:
        app.config.from_object(config_class)
    else:
        app.config.from_object('config.Config')
    
    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    login_manager.login_view = 'auth.login'
    
    # Register blueprints
    from app.views.main import bp as main_bp
    app.register_blueprint(main_bp)
    
    from app.views.auth import bp as auth_bp
    app.register_blueprint(auth_bp, url_prefix='/auth')
    
    return app

# Import models for migrations
from app import models
```

### Configuration Management
```python
# config.py
import os
from dotenv import load_dotenv

basedir = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(basedir, '.env'))

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'hard-to-guess-string'
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'app.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    MAIL_SERVER = os.environ.get('MAIL_SERVER')
    MAIL_PORT = int(os.environ.get('MAIL_PORT') or 587)
    MAIL_USE_TLS = os.environ.get('MAIL_USE_TLS', 'true').lower() in ['true', 'on', '1']
    MAIL_USERNAME = os.environ.get('MAIL_USERNAME')
    MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD')

class DevelopmentConfig(Config):
    DEBUG = True

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'

class ProductionConfig(Config):
    DEBUG = False

config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}
```

## Models and Database

### SQLAlchemy Models
```python
# app/models.py
from app import db, login_manager
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True)
    email = db.Column(db.String(120), index=True, unique=True)
    password_hash = db.Column(db.String(128))
    posts = db.relationship('Post', backref='author', lazy='dynamic')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return f'<User {self.username}>'

class Post(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    body = db.Column(db.Text)
    timestamp = db.Column(db.DateTime, index=True, default=datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    
    def __repr__(self):
        return f'<Post {self.title}>'

@login_manager.user_loader
def load_user(id):
    return User.query.get(int(id))
```

### Database Migrations
```bash
# Initialize migrations
flask db init

# Create migration
flask db migrate -m "Add user and post tables"

# Apply migration
flask db upgrade

# Downgrade migration
flask db downgrade
```

## Views and Routing

### Blueprint Structure
```python
# app/views/main.py
from flask import Blueprint, render_template, request, flash, redirect, url_for
from flask_login import login_required, current_user
from app import db
from app.models import Post

bp = Blueprint('main', __name__)

@bp.route('/')
@bp.route('/index')
def index():
    posts = Post.query.order_by(Post.timestamp.desc()).all()
    return render_template('index.html', posts=posts)

@bp.route('/create', methods=['GET', 'POST'])
@login_required
def create_post():
    if request.method == 'POST':
        title = request.form['title']
        body = request.form['body']
        
        if not title:
            flash('Title is required!')
        else:
            post = Post(title=title, body=body, author=current_user)
            db.session.add(post)
            db.session.commit()
            flash('Your post has been created!')
            return redirect(url_for('main.index'))
    
    return render_template('create_post.html')

@bp.route('/post/<int:id>')
def show_post(id):
    post = Post.query.get_or_404(id)
    return render_template('post.html', post=post)
```

### Authentication Blueprint
```python
# app/views/auth.py
from flask import Blueprint, render_template, redirect, url_for, flash, request
from flask_login import login_user, logout_user, login_required, current_user
from werkzeug.urls import url_parse
from app import db
from app.models import User

bp = Blueprint('auth', __name__)

@bp.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('main.index'))
    
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        remember_me = bool(request.form.get('remember_me'))
        
        user = User.query.filter_by(username=username).first()
        
        if user is None or not user.check_password(password):
            flash('Invalid username or password')
            return redirect(url_for('auth.login'))
        
        login_user(user, remember=remember_me)
        
        next_page = request.args.get('next')
        if not next_page or url_parse(next_page).netloc != '':
            next_page = url_for('main.index')
        
        return redirect(next_page)
    
    return render_template('auth/login.html')

@bp.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('main.index'))

@bp.route('/register', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('main.index'))
    
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        
        # Validation
        if User.query.filter_by(username=username).first():
            flash('Username already exists')
            return redirect(url_for('auth.register'))
        
        if User.query.filter_by(email=email).first():
            flash('Email already registered')
            return redirect(url_for('auth.register'))
        
        user = User(username=username, email=email)
        user.set_password(password)
        db.session.add(user)
        db.session.commit()
        
        flash('Registration successful')
        return redirect(url_for('auth.login'))
    
    return render_template('auth/register.html')
```

## Forms and Validation

### Flask-WTF Forms
```python
# app/forms.py
from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, PasswordField, BooleanField, SubmitField
from wtforms.validators import DataRequired, Length, Email, EqualTo, ValidationError
from app.models import User

class LoginForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    remember_me = BooleanField('Remember Me')
    submit = SubmitField('Sign In')

class RegistrationForm(FlaskForm):
    username = StringField('Username', validators=[
        DataRequired(), 
        Length(min=4, max=64)
    ])
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[
        DataRequired(),
        Length(min=8)
    ])
    password2 = PasswordField('Repeat Password', validators=[
        DataRequired(), 
        EqualTo('password')
    ])
    submit = SubmitField('Register')

    def validate_username(self, username):
        user = User.query.filter_by(username=username.data).first()
        if user is not None:
            raise ValidationError('Please use a different username.')

    def validate_email(self, email):
        user = User.query.filter_by(email=email.data).first()
        if user is not None:
            raise ValidationError('Please use a different email.')

class PostForm(FlaskForm):
    title = StringField('Title', validators=[
        DataRequired(),
        Length(min=1, max=100)
    ])
    body = TextAreaField('Content', validators=[
        DataRequired(),
        Length(min=1, max=1000)
    ])
    submit = SubmitField('Create Post')
```

### Using Forms in Views
```python
# Updated view using forms
@bp.route('/create', methods=['GET', 'POST'])
@login_required
def create_post():
    form = PostForm()
    if form.validate_on_submit():
        post = Post(
            title=form.title.data,
            body=form.body.data,
            author=current_user
        )
        db.session.add(post)
        db.session.commit()
        flash('Your post has been created!')
        return redirect(url_for('main.index'))
    
    return render_template('create_post.html', form=form)
```

## Templates and Frontend

### Base Template
```html
<!-- app/templates/base.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% if title %}{{ title }} - MyApp{% else %}MyApp{% endif %}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="{{ url_for('main.index') }}">MyApp</a>
            <div class="navbar-nav ms-auto">
                {% if current_user.is_authenticated %}
                    <a class="nav-link" href="{{ url_for('main.create_post') }}">New Post</a>
                    <a class="nav-link" href="{{ url_for('auth.logout') }}">Logout</a>
                {% else %}
                    <a class="nav-link" href="{{ url_for('auth.login') }}">Login</a>
                    <a class="nav-link" href="{{ url_for('auth.register') }}">Register</a>
                {% endif %}
            </div>
        </div>
    </nav>

    <main class="container mt-4">
        {% with messages = get_flashed_messages() %}
            {% if messages %}
                {% for message in messages %}
                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                        {{ message }}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                {% endfor %}
            {% endif %}
        {% endwith %}

        {% block content %}{% endblock %}
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

### Form Template with Error Handling
```html
<!-- app/templates/create_post.html -->
{% extends "base.html" %}

{% block content %}
<h2>Create New Post</h2>

<form method="POST">
    {{ form.hidden_tag() }}
    
    <div class="mb-3">
        {{ form.title.label(class="form-label") }}
        {{ form.title(class="form-control" + (" is-invalid" if form.title.errors else "")) }}
        {% if form.title.errors %}
            {% for error in form.title.errors %}
                <div class="invalid-feedback">{{ error }}</div>
            {% endfor %}
        {% endif %}
    </div>
    
    <div class="mb-3">
        {{ form.body.label(class="form-label") }}
        {{ form.body(class="form-control" + (" is-invalid" if form.body.errors else ""), rows="5") }}
        {% if form.body.errors %}
            {% for error in form.body.errors %}
                <div class="invalid-feedback">{{ error }}</div>
            {% endfor %}
        {% endif %}
    </div>
    
    <div class="mb-3">
        {{ form.submit(class="btn btn-primary") }}
        <a href="{{ url_for('main.index') }}" class="btn btn-secondary">Cancel</a>
    </div>
</form>
{% endblock %}
```

## API Development

### RESTful API with Flask-RESTful
```python
# app/api/__init__.py
from flask import Blueprint
from flask_restful import Api

bp = Blueprint('api', __name__)
api = Api(bp)

from app.api import users, posts
```

### API Resources
```python
# app/api/posts.py
from flask_restful import Resource, request, marshal_with, fields
from flask_login import login_required, current_user
from app.models import Post
from app import db

post_fields = {
    'id': fields.Integer,
    'title': fields.String,
    'body': fields.String,
    'timestamp': fields.DateTime(dt_format='iso8601'),
    'author': fields.String(attribute='author.username')
}

class PostResource(Resource):
    @marshal_with(post_fields)
    def get(self, id):
        post = Post.query.get_or_404(id)
        return post

    @login_required
    def delete(self, id):
        post = Post.query.get_or_404(id)
        if post.author != current_user:
            return {'message': 'Permission denied'}, 403
        
        db.session.delete(post)
        db.session.commit()
        return {'message': 'Post deleted'}, 200

class PostListResource(Resource):
    @marshal_with(post_fields)
    def get(self):
        posts = Post.query.order_by(Post.timestamp.desc()).all()
        return posts

    @login_required
    @marshal_with(post_fields)
    def post(self):
        data = request.get_json()
        
        post = Post(
            title=data['title'],
            body=data.get('body', ''),
            author=current_user
        )
        
        db.session.add(post)
        db.session.commit()
        
        return post, 201

# Register resources
from app.api import api
api.add_resource(PostResource, '/posts/<int:id>')
api.add_resource(PostListResource, '/posts')
```

## Testing Flask Applications

### Test Configuration
```python
# tests/conftest.py
import pytest
from app import create_app, db
from app.models import User, Post
from config import TestingConfig

@pytest.fixture
def app():
    app = create_app(TestingConfig)
    
    with app.app_context():
        db.create_all()
        yield app
        db.drop_all()

@pytest.fixture
def client(app):
    return app.test_client()

@pytest.fixture
def runner(app):
    return app.test_cli_runner()

@pytest.fixture
def user(app):
    user = User(username='testuser', email='test@example.com')
    user.set_password('testpass')
    db.session.add(user)
    db.session.commit()
    return user
```

### Testing Views
```python
# tests/test_views.py
def test_index_page(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b'Welcome' in response.data

def test_login_required(client):
    response = client.get('/create')
    assert response.status_code == 302  # Redirect to login

def test_user_login(client, user):
    response = client.post('/auth/login', data={
        'username': 'testuser',
        'password': 'testpass'
    }, follow_redirects=True)
    
    assert response.status_code == 200
    assert b'Welcome' in response.data

def test_create_post(client, user):
    # Login first
    client.post('/auth/login', data={
        'username': 'testuser',
        'password': 'testpass'
    })
    
    # Create post
    response = client.post('/create', data={
        'title': 'Test Post',
        'body': 'This is a test post'
    }, follow_redirects=True)
    
    assert response.status_code == 200
    assert b'Test Post' in response.data
```

## Deployment

### Production Configuration
```python
# app/__init__.py additions for production
def create_app(config_class=None):
    app = Flask(__name__)
    
    # ... existing configuration ...
    
    if not app.debug and not app.testing:
        # Logging setup
        import logging
        from logging.handlers import RotatingFileHandler
        
        if not os.path.exists('logs'):
            os.mkdir('logs')
        
        file_handler = RotatingFileHandler(
            'logs/myapp.log', maxBytes=10240, backupCount=10
        )
        file_handler.setFormatter(logging.Formatter(
            '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
        ))
        file_handler.setLevel(logging.INFO)
        app.logger.addHandler(file_handler)
        
        app.logger.setLevel(logging.INFO)
        app.logger.info('MyApp startup')
    
    return app
```

### Docker Setup
```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "run:app"]
```

### Environment Variables
```bash
# .env
SECRET_KEY=your-secret-key-here
DATABASE_URL=sqlite:///app.db
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=1
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-password
```

## Best Practices Checklist

- [ ] Use application factory pattern
- [ ] Organize code with blueprints
- [ ] Implement proper error handling
- [ ] Use Flask-WTF for forms and CSRF protection
- [ ] Implement user authentication and authorization
- [ ] Write comprehensive tests
- [ ] Use environment variables for configuration
- [ ] Implement logging for production
- [ ] Use database migrations
- [ ] Follow REST conventions for APIs
- [ ] Implement input validation
- [ ] Use HTTPS in production
- [ ] Set up proper session management
- [ ] Implement rate limiting for APIs
- [ ] Document your API endpoints