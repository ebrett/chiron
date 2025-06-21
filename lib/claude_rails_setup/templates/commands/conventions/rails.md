# Rails Development Conventions

You are an expert in Ruby on Rails, PostgreSQL, Hotwire (Turbo and Stimulus), and Tailwind CSS.

## Code Style and Structure
- Write concise, idiomatic Ruby code with accurate examples
- Follow Rails conventions and best practices
- Use object-oriented and functional programming patterns as appropriate
- Prefer iteration and modularization over code duplication
- Use descriptive variable and method names (e.g., `user_signed_in?`, `calculate_total`)
- Structure files according to Rails conventions (MVC, concerns, helpers, etc.)

## Naming Conventions
- Use snake_case for file names, method names, and variables
- Use CamelCase for class and module names
- Follow Rails naming conventions for models, controllers, and views
- Use meaningful names that express intent

## Ruby and Rails Usage
- Use Ruby 3.x features when appropriate (pattern matching, endless methods)
- Leverage Rails' built-in helpers and methods
- Use ActiveRecord effectively for database operations
- Follow RESTful routing conventions
- Use concerns for shared behavior across models or controllers

## Rails 8 Specific Features
- Use the `encrypts` macro for sensitive data:
  ```ruby
  class User < ApplicationRecord
    encrypts :api_key
    encrypts :personal_data
  end
  ```
- Leverage Solid Queue for background jobs
- Use Solid Cache for caching
- Take advantage of Propshaft for assets

## Syntax and Formatting
- Follow the Ruby Style Guide (https://rubystyle.guide/)
- Use Ruby's expressive syntax (e.g., `unless`, `||=`, `&.`)
- Prefer single quotes for strings unless interpolation is needed
- Use modern hash syntax: `{ key: value }`
- Keep methods small and focused

## Error Handling and Validation
- Use exceptions for exceptional cases, not for control flow
- Implement proper error logging and user-friendly messages
- Use ActiveModel validations in models
- Handle errors gracefully in controllers with appropriate responses
- Use strong parameters for mass assignment protection

## Database and ActiveRecord
- Write efficient queries using includes, joins, or select
- Avoid N+1 queries with eager loading
- Use database indexes effectively
- Write reversible migrations
- Use scopes for commonly used queries
- Leverage ActiveRecord callbacks judiciously

## Testing Approach
- Write comprehensive tests using RSpec
- Follow TDD/BDD practices
- Use factories (FactoryBot) for test data
- Write unit tests for models and services
- Write integration tests for controllers
- Write system tests for user workflows
- Aim for high test coverage

## UI and Frontend
- Use Hotwire (Turbo and Stimulus) for dynamic interactions
- Implement responsive design with Tailwind CSS
- Use Rails view helpers and partials to keep views DRY
- Leverage ViewComponent for reusable UI components
- Use Turbo Frames for partial page updates
- Use Turbo Streams for real-time updates

## Performance Optimization
- Use database indexing effectively
- Implement caching strategies:
  - Fragment caching for views
  - Russian Doll caching for nested content
  - Low-level caching for expensive operations
- Use background jobs for time-consuming tasks
- Optimize asset delivery with CDNs
- Monitor and optimize database queries

## Security Best Practices
- Use strong parameters in controllers
- Implement proper authentication (e.g., Devise, custom)
- Use authorization (e.g., Pundit, CanCanCan)
- Protect against common vulnerabilities:
  - XSS (Rails handles by default)
  - CSRF (use Rails tokens)
  - SQL injection (use parameterized queries)
- Keep dependencies updated
- Use encrypted credentials for secrets

## Service Objects Pattern
```ruby
# app/services/user_registration_service.rb
class UserRegistrationService
  def initialize(params)
    @params = params
  end
  
  def call
    ActiveRecord::Base.transaction do
      user = User.create!(@params)
      send_welcome_email(user)
      track_registration(user)
      user
    end
  end
  
  private
  
  def send_welcome_email(user)
    UserMailer.welcome(user).deliver_later
  end
  
  def track_registration(user)
    Analytics.track('User Registered', user_id: user.id)
  end
end
```

## Background Jobs
```ruby
# app/jobs/data_import_job.rb
class DataImportJob < ApplicationJob
  queue_as :default
  
  def perform(file_path)
    DataImporter.new(file_path).import
  rescue StandardError => e
    Rails.logger.error "Import failed: #{e.message}"
    raise
  end
end
```

## API Development
- Use Rails API mode for API-only applications
- Implement versioning for APIs
- Use serializers for JSON responses
- Implement proper authentication (JWT, OAuth)
- Follow REST principles
- Document APIs thoroughly

## Deployment Considerations
- Use environment variables for configuration
- Implement health check endpoints
- Set up proper logging and monitoring
- Use asset precompilation
- Configure database connection pooling
- Set up SSL/TLS properly

## Common Pitfalls to Avoid
- Don't use inline styles or JavaScript
- Avoid fat controllers - keep them thin
- Don't skip validations or tests
- Avoid modifying core classes
- Don't store sensitive data in code
- Avoid premature optimization

Remember: Convention over Configuration - follow Rails conventions unless you have a very good reason not to!