# Test-Driven Development (TDD) Workflow

## Core Principles

1. **Red**: Write a failing test first and **verify it fails**
2. **Green**: Write minimal code to make the test pass
3. **Refactor**: Improve the code while keeping tests green

## Key: Always Verify Test Failure First

**Critical**: Before writing implementation, run the test to confirm it fails for the expected reason. This prevents false positives and ensures your test actually validates the behavior.

## TDD Process

### Step 1: Think Through Complex Features
For complex functionality, use "think" to trigger extended thinking mode to plan your test strategy.

### Step 2: Write a Failing Test
```ruby
# spec/models/user_spec.rb
it 'returns the full name' do
  user = User.new(first_name: 'John', last_name: 'Doe')
  expect(user.full_name).to eq('John Doe')
end
```

### Step 3: **VERIFY** Test Fails (Critical Step)
```bash
bin/rspec spec/models/user_spec.rb
# Expected failure: undefined method `full_name'
# CONFIRM: Test fails for the RIGHT reason
```

### Step 4: Write Minimal Code
```ruby
# app/models/user.rb
def full_name
  "#{first_name} #{last_name}"
end
```

### Step 5: Run Test (See it Pass)
```bash
bin/rspec spec/models/user_spec.rb
# All tests should pass
```

### Step 6: Refactor if Needed
```ruby
# Improved version
def full_name
  [first_name, last_name].compact.join(' ')
end
```

## Rules

### Write One Test at a Time
- Write test
- See it fail
- Make it pass
- Refactor
- Repeat

### Only Write Code to Pass Current Test
- Don't add functionality not required by current test
- Don't anticipate future needs
- Keep it simple

### Committing Rules
- Only commit when all tests pass
- Never commit with failing tests
- Include all changed files in commit

### Test Integrity
- Never delete or modify tests just to make them pass
- If a test is wrong, fix it and document why
- Use `skip` or `pending` for incomplete tests
- **Avoid overfitting**: Ensure tests validate real behavior, not just current implementation
- Write tests that would catch regressions if the implementation changed

## Test Plan Management

### Create Test Plan First
```markdown
## User Model Test Plan
- [ ] validates presence of email
- [ ] validates uniqueness of email
- [ ] validates email format
- [ ] returns full name
- [ ] returns initials
- [ ] has many posts
- [ ] scopes for active users
```

### Track Progress
- Check off completed tests
- Add new tests as discovered
- Keep plan updated

## Common Patterns

### Model Testing
```ruby
describe User do
  describe 'validations' do
    it { should validate_presence_of(:email) }
  end
  
  describe '#full_name' do
    it 'returns concatenated name' do
      # test here
    end
  end
end
```

### Controller Testing
```ruby
describe UsersController do
  describe 'GET #index' do
    before { get :index }
    
    it 'returns success' do
      expect(response).to be_successful
    end
  end
end
```

### System Testing
```ruby
describe 'User registration' do
  it 'allows new users to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@example.com'
    # ... more steps
    expect(page).to have_content('Welcome!')
  end
end
```

## Best Practices

### Good Tests Are:
- **Fast**: Run quickly
- **Independent**: Don't depend on other tests
- **Repeatable**: Same result every time
- **Self-Validating**: Clear pass/fail
- **Timely**: Written before code

### Test Naming
```ruby
# Bad
it 'works' do
it 'test user' do

# Good
it 'returns full name when both names present' do
it 'returns only first name when last name is nil' do
```

### Edge Cases
Always test:
- Nil values
- Empty strings
- Boundary conditions
- Invalid input
- Error conditions

## Useful Commands

```bash
# Run specific test file
bin/rspec spec/models/user_spec.rb

# Run specific line
bin/rspec spec/models/user_spec.rb:42

# Run with documentation format
bin/rspec --format documentation

# Run only failing tests
bin/rspec --only-failures

# Run tests matching pattern
bin/rspec --example "full name"
```

## When to Break TDD Rules

Acceptable exceptions:
- Exploring new libraries/APIs
- Spike solutions (throw away after)
- UI styling (but test behavior)

Always return to TDD after exploration!