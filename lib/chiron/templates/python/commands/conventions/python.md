# Python Development Conventions

You are an expert in Python, modern web frameworks (Django, FastAPI, Flask), and Python best practices.

## Code Style and Structure
- Write clear, idiomatic Python code following PEP 8
- Use type hints to improve code clarity and catch errors early
- Prefer composition over inheritance
- Keep functions small and focused (single responsibility)
- Use descriptive names that convey intent
- Structure code in logical modules and packages

## Naming Conventions
- Use snake_case for functions, variables, and module names
- Use PascalCase for class names
- Use UPPER_SNAKE_CASE for constants
- Prefix "private" attributes/methods with underscore (_)
- Use descriptive names over comments when possible

## Python Best Practices
- Use Python 3.8+ features appropriately:
  - f-strings for formatting
  - Type hints and typing module
  - Dataclasses for simple data structures
  - Pattern matching (3.10+) where beneficial
- List comprehensions for simple transformations
- Generator expressions for memory efficiency
- Context managers (with statements) for resource management
- Pathlib over os.path for file operations

## Type Hints
```python
from typing import List, Dict, Optional, Union

def process_data(
    items: List[str], 
    config: Optional[Dict[str, Any]] = None
) -> Dict[str, int]:
    """Process items according to config."""
    config = config or {}
    return {item: len(item) for item in items}
```

## Error Handling
- Use specific exception types
- Avoid bare except clauses
- Use logging instead of print for debugging
- Fail fast with clear error messages
- Handle exceptions at appropriate levels

```python
import logging

logger = logging.getLogger(__name__)

try:
    result = risky_operation()
except ValueError as e:
    logger.error(f"Invalid value: {e}")
    raise
except Exception as e:
    logger.exception("Unexpected error")
    # Handle or re-raise appropriately
```

## Testing with pytest
- Write tests before or alongside implementation
- Use fixtures for test data and setup
- Parametrize tests for multiple scenarios
- Mock external dependencies
- Aim for high coverage but focus on behavior

```python
import pytest
from unittest.mock import Mock, patch

@pytest.fixture
def sample_data():
    return {"key": "value"}

@pytest.mark.parametrize("input,expected", [
    ("hello", 5),
    ("", 0),
    ("test", 4),
])
def test_string_length(input, expected):
    assert len(input) == expected

def test_with_mock():
    mock_service = Mock()
    mock_service.get_data.return_value = {"status": "ok"}
    assert process_with_service(mock_service)["status"] == "ok"
```

## Django Specific
```python
# Models
from django.db import models
from django.urls import reverse

class Article(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return self.title
    
    def get_absolute_url(self):
        return reverse('article_detail', args=[self.slug])

# Views (Class-Based)
from django.views.generic import ListView, DetailView
from django.contrib.auth.mixins import LoginRequiredMixin

class ArticleListView(ListView):
    model = Article
    paginate_by = 10
    context_object_name = 'articles'

# Forms
from django import forms

class ArticleForm(forms.ModelForm):
    class Meta:
        model = Article
        fields = ['title', 'content']
        widgets = {
            'content': forms.Textarea(attrs={'rows': 10}),
        }
```

## FastAPI Specific
```python
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

app = FastAPI(title="My API", version="1.0.0")

# Pydantic Models
class ItemBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = None
    price: float = Field(..., gt=0)

class ItemCreate(ItemBase):
    pass

class Item(ItemBase):
    id: int
    created_at: datetime
    
    class Config:
        orm_mode = True

# Dependency Injection
async def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Endpoints
@app.post("/items/", response_model=Item)
async def create_item(
    item: ItemCreate, 
    db: Session = Depends(get_db)
):
    db_item = ItemModel(**item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

@app.get("/items/{item_id}", response_model=Item)
async def read_item(item_id: int, db: Session = Depends(get_db)):
    item = db.query(ItemModel).filter(ItemModel.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item
```

## Async/Await Best Practices
```python
import asyncio
import aiohttp

async def fetch_data(session: aiohttp.ClientSession, url: str) -> dict:
    async with session.get(url) as response:
        return await response.json()

async def fetch_multiple(urls: List[str]) -> List[dict]:
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_data(session, url) for url in urls]
        return await asyncio.gather(*tasks)
```

## Data Validation with Pydantic
```python
from pydantic import BaseModel, validator, Field
from typing import Optional
from datetime import datetime

class User(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    email: str
    age: Optional[int] = Field(None, ge=0, le=150)
    created_at: datetime = Field(default_factory=datetime.now)
    
    @validator('email')
    def validate_email(cls, v):
        if '@' not in v:
            raise ValueError('Invalid email')
        return v.lower()
```

## Database Patterns
```python
# SQLAlchemy with FastAPI
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class UserModel(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

# Repository Pattern
class UserRepository:
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_username(self, username: str) -> Optional[UserModel]:
        return self.db.query(UserModel).filter(
            UserModel.username == username
        ).first()
    
    def create(self, user_data: dict) -> UserModel:
        user = UserModel(**user_data)
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user
```

## Configuration Management
```python
from pydantic import BaseSettings
from functools import lru_cache

class Settings(BaseSettings):
    app_name: str = "My App"
    debug: bool = False
    database_url: str
    secret_key: str
    
    class Config:
        env_file = ".env"

@lru_cache()
def get_settings():
    return Settings()

# Usage
settings = get_settings()
```

## Logging Best Practices
```python
import logging
import sys

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('app.log')
    ]
)

logger = logging.getLogger(__name__)

# Use structured logging
logger.info(
    "User action", 
    extra={"user_id": 123, "action": "login", "ip": "192.168.1.1"}
)
```

## Performance Optimization
- Use generators for large datasets
- Cache expensive operations with functools.lru_cache
- Profile code with cProfile before optimizing
- Use appropriate data structures (sets for membership, deque for queues)
- Leverage asyncio for I/O-bound operations
- Consider multiprocessing for CPU-bound tasks

## Security Best Practices
- Never hardcode secrets
- Use environment variables for configuration
- Validate all input data
- Use parameterized queries to prevent SQL injection
- Hash passwords with bcrypt or argon2
- Implement proper authentication and authorization
- Keep dependencies updated

## Common Pitfalls to Avoid
- Mutable default arguments
- Modifying lists while iterating
- Using `is` for value comparison (use `==`)
- Catching too broad exceptions
- Not closing resources properly
- Circular imports
- Using global variables excessively

Remember: "Explicit is better than implicit" - The Zen of Python