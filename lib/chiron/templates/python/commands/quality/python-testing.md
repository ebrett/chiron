# Python Testing Patterns

Comprehensive guide for testing Python applications using pytest and related tools.

## Testing Philosophy

### Test Pyramid Structure
- **Unit Tests (70%)**: Fast, focused tests for individual functions/methods
- **Integration Tests (20%)**: Test interactions between components
- **End-to-End Tests (10%)**: Full application workflow tests

### TDD Approach
1. Write a failing test
2. Write minimal code to make it pass
3. Refactor while keeping tests green

## pytest Fundamentals

### Basic Test Structure
```python
# test_example.py
import pytest
from myapp import Calculator

def test_addition():
    calc = Calculator()
    result = calc.add(2, 3)
    assert result == 5

def test_division_by_zero():
    calc = Calculator()
    with pytest.raises(ZeroDivisionError):
        calc.divide(10, 0)

def test_with_multiple_assertions():
    calc = Calculator()
    assert calc.add(1, 1) == 2
    assert calc.subtract(5, 3) == 2
    assert calc.multiply(3, 4) == 12
```

### Test Discovery and Execution
```bash
# Run all tests
pytest

# Run specific test file
pytest test_calculator.py

# Run specific test
pytest test_calculator.py::test_addition

# Run with verbose output
pytest -v

# Run with coverage
pytest --cov=myapp

# Run parallel tests
pytest -n auto  # Requires pytest-xdist
```

## Fixtures for Test Setup

### Basic Fixtures
```python
import pytest
from myapp import Database, User

@pytest.fixture
def db_connection():
    """Provide a database connection for tests."""
    db = Database()
    db.connect()
    yield db
    db.disconnect()

@pytest.fixture
def sample_user():
    """Provide a sample user for tests."""
    return User(
        username="testuser",
        email="test@example.com",
        age=25
    )

def test_user_creation(db_connection, sample_user):
    user_id = db_connection.create_user(sample_user)
    assert user_id is not None
    
    retrieved_user = db_connection.get_user(user_id)
    assert retrieved_user.username == "testuser"
```

### Fixture Scopes
```python
@pytest.fixture(scope="session")
def database_setup():
    """Run once per test session."""
    # Setup expensive resources
    yield
    # Cleanup

@pytest.fixture(scope="module")
def api_client():
    """Run once per test module."""
    client = APIClient()
    client.authenticate()
    yield client
    client.logout()

@pytest.fixture(scope="function")  # Default scope
def clean_environment():
    """Run for each test function."""
    setup_test_environment()
    yield
    cleanup_test_environment()
```

### Parameterized Tests
```python
import pytest

@pytest.mark.parametrize("input,expected", [
    (2, 4),
    (3, 9),
    (4, 16),
    (5, 25),
])
def test_square_function(input, expected):
    from myapp import square
    assert square(input) == expected

@pytest.mark.parametrize("username,email,valid", [
    ("user1", "user1@example.com", True),
    ("", "user2@example.com", False),  # Empty username
    ("user3", "invalid-email", False),  # Invalid email
    ("user4", "", False),  # Empty email
])
def test_user_validation(username, email, valid):
    from myapp import User
    user = User(username=username, email=email)
    assert user.is_valid() == valid
```

## Mocking and Patching

### Using unittest.mock
```python
from unittest.mock import Mock, patch, MagicMock
import pytest

# Mock objects
def test_with_mock():
    mock_service = Mock()
    mock_service.get_data.return_value = {"status": "success"}
    mock_service.process_data.side_effect = ValueError("Invalid data")
    
    # Test code that uses mock_service
    assert mock_service.get_data()["status"] == "success"
    
    with pytest.raises(ValueError):
        mock_service.process_data("bad_data")

# Patching external dependencies
@patch('myapp.external_api.requests.get')
def test_api_call(mock_get):
    from myapp.external_api import fetch_user_data
    
    # Setup mock response
    mock_response = Mock()
    mock_response.json.return_value = {"id": 1, "name": "John"}
    mock_response.status_code = 200
    mock_get.return_value = mock_response
    
    # Test
    result = fetch_user_data(user_id=1)
    assert result["name"] == "John"
    mock_get.assert_called_once_with("https://api.example.com/users/1")
```

### pytest-mock Plugin
```python
# pip install pytest-mock
def test_with_mocker(mocker):
    # Mock using mocker fixture
    mock_service = mocker.Mock()
    mock_service.get_user.return_value = {"id": 1, "name": "John"}
    
    # Patch class method
    mocker.patch('myapp.UserService.get_user', return_value={"id": 1})
    
    # Patch with side effect
    mocker.patch('myapp.send_email', side_effect=Exception("Email failed"))
```

## Testing Async Code

### Testing Async Functions
```python
import pytest
import asyncio

# Mark async tests
@pytest.mark.asyncio
async def test_async_function():
    from myapp import fetch_data_async
    
    result = await fetch_data_async()
    assert result is not None

# Async fixtures
@pytest.fixture
async def async_client():
    client = AsyncClient()
    await client.connect()
    yield client
    await client.disconnect()

@pytest.mark.asyncio
async def test_with_async_fixture(async_client):
    result = await async_client.get_data()
    assert result["status"] == "ok"
```

### Testing with aioresponses
```python
# pip install aioresponses
import aiohttp
from aioresponses import aioresponses

@pytest.mark.asyncio
async def test_async_http_call():
    with aioresponses() as mock:
        mock.get('http://api.example.com/data', payload={"key": "value"})
        
        async with aiohttp.ClientSession() as session:
            result = await fetch_from_api(session)
            assert result["key"] == "value"
```

## Database Testing

### SQLAlchemy Testing
```python
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from myapp.models import Base, User

@pytest.fixture(scope="session")
def engine():
    return create_engine("sqlite:///:memory:")

@pytest.fixture(scope="session")
def tables(engine):
    Base.metadata.create_all(engine)
    yield
    Base.metadata.drop_all(engine)

@pytest.fixture
def db_session(engine, tables):
    Session = sessionmaker(bind=engine)
    session = Session()
    yield session
    session.rollback()
    session.close()

def test_user_creation(db_session):
    user = User(username="testuser", email="test@example.com")
    db_session.add(user)
    db_session.commit()
    
    assert user.id is not None
    
    retrieved_user = db_session.query(User).filter_by(username="testuser").first()
    assert retrieved_user.email == "test@example.com"
```

### Django Testing
```python
from django.test import TestCase, Client
from django.contrib.auth.models import User
from myapp.models import Article

class ArticleTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            password='testpass'
        )
        self.article = Article.objects.create(
            title="Test Article",
            content="Test content",
            author=self.user
        )
    
    def test_article_creation(self):
        self.assertEqual(self.article.title, "Test Article")
        self.assertEqual(self.article.author, self.user)
    
    def test_article_str_representation(self):
        self.assertEqual(str(self.article), "Test Article")

class ArticleViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(
            username='testuser',
            password='testpass'
        )
    
    def test_article_list_view(self):
        response = self.client.get('/articles/')
        self.assertEqual(response.status_code, 200)
    
    def test_create_article_requires_auth(self):
        response = self.client.post('/articles/create/', {
            'title': 'New Article',
            'content': 'Content'
        })
        self.assertEqual(response.status_code, 302)  # Redirect to login
```

## API Testing

### FastAPI Testing
```python
from fastapi.testclient import TestClient
from myapp.main import app

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}

def test_create_item():
    response = client.post("/items/", json={
        "name": "Test Item",
        "description": "Test Description",
        "price": 10.5
    })
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Test Item"
    assert "id" in data

def test_authentication():
    # Test without auth
    response = client.get("/protected")
    assert response.status_code == 401
    
    # Test with auth
    headers = {"Authorization": "Bearer valid_token"}
    response = client.get("/protected", headers=headers)
    assert response.status_code == 200
```

### Testing with requests-mock
```python
import requests
import requests_mock

def test_external_api_call():
    with requests_mock.Mocker() as mock:
        mock.get('https://api.example.com/users/1', json={
            'id': 1,
            'name': 'John Doe'
        })
        
        response = requests.get('https://api.example.com/users/1')
        assert response.json()['name'] == 'John Doe'
```

## Test Organization

### Conftest.py for Shared Fixtures
```python
# conftest.py
import pytest
from myapp import create_app

@pytest.fixture(scope="session")
def app():
    """Create application for testing."""
    app = create_app(testing=True)
    return app

@pytest.fixture
def client(app):
    """Create test client."""
    return app.test_client()

@pytest.fixture
def runner(app):
    """Create CLI runner."""
    return app.test_cli_runner()
```

### Test Markers
```python
import pytest

@pytest.mark.slow
def test_slow_operation():
    # Test that takes a long time
    pass

@pytest.mark.integration
def test_database_integration():
    # Integration test
    pass

@pytest.mark.unit  
def test_pure_function():
    # Unit test
    pass

# Run specific marked tests
# pytest -m slow
# pytest -m "not slow"
# pytest -m "unit and not slow"
```

## Coverage and Quality

### Coverage Configuration
```ini
# .coveragerc
[run]
source = myapp
omit = 
    */venv/*
    */tests/*
    */migrations/*
    manage.py
    setup.py

[report]
exclude_lines =
    pragma: no cover
    def __repr__
    raise AssertionError
    raise NotImplementedError
```

### Property-Based Testing with Hypothesis
```python
from hypothesis import given, strategies as st

@given(st.integers(), st.integers())
def test_addition_commutative(a, b):
    assert add(a, b) == add(b, a)

@given(st.lists(st.integers(), min_size=1))
def test_sort_idempotent(numbers):
    sorted_once = sorted(numbers)
    sorted_twice = sorted(sorted_once)
    assert sorted_once == sorted_twice
```

## Testing Best Practices

### Test Naming
```python
# Good test names describe the scenario
def test_should_return_empty_list_when_no_users_exist():
    pass

def test_should_raise_validation_error_when_email_is_invalid():
    pass

def test_should_create_user_with_hashed_password():
    pass
```

### Test Structure (Arrange-Act-Assert)
```python
def test_user_registration():
    # Arrange
    user_data = {
        "username": "newuser",
        "email": "newuser@example.com",
        "password": "securepassword"
    }
    
    # Act
    result = register_user(user_data)
    
    # Assert
    assert result.success is True
    assert result.user.username == "newuser"
    assert result.user.password != "securepassword"  # Should be hashed
```

### Test Data Builders
```python
class UserBuilder:
    def __init__(self):
        self.username = "defaultuser"
        self.email = "default@example.com"
        self.age = 25
    
    def with_username(self, username):
        self.username = username
        return self
    
    def with_email(self, email):
        self.email = email
        return self
    
    def build(self):
        return User(
            username=self.username,
            email=self.email,
            age=self.age
        )

# Usage
def test_user_validation():
    user = (UserBuilder()
            .with_username("testuser")
            .with_email("test@example.com")
            .build())
    
    assert user.is_valid() is True
```

## Continuous Integration

### GitHub Actions Example
```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.8, 3.9, "3.10", "3.11"]
    
    steps:
    - uses: actions/checkout@v3
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements-dev.txt
    
    - name: Run tests
      run: |
        pytest --cov=myapp --cov-report=xml
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
```

## Testing Checklist

- [ ] Tests are fast and focused
- [ ] Each test has a single responsibility
- [ ] Test names clearly describe the scenario
- [ ] Tests are independent and can run in any order
- [ ] Mock external dependencies
- [ ] Test both happy path and edge cases
- [ ] Aim for high coverage but focus on behavior
- [ ] Use fixtures to reduce duplication
- [ ] Tests are part of CI/CD pipeline
- [ ] Flaky tests are investigated and fixed