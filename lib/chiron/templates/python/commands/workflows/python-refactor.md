# Python Refactoring Workflow

Follow this systematic approach when refactoring Python code to improve its structure, readability, and maintainability.

## Pre-Refactoring Checklist

- [ ] Ensure comprehensive test coverage exists
- [ ] Run all tests and confirm they pass
- [ ] Commit current working state to version control
- [ ] Identify specific refactoring goals
- [ ] Review Python conventions and PEP 8

## Refactoring Patterns

### 1. Extract Function
```python
# Before
def process_user_data(users):
    for user in users:
        # Complex validation logic
        if user.age < 18:
            user.status = 'minor'
        elif user.age >= 65:
            user.status = 'senior'
        else:
            user.status = 'adult'
        
        # Complex calculation
        user.discount = calculate_complex_discount(user)

# After
def process_user_data(users):
    for user in users:
        user.status = categorize_user_by_age(user.age)
        user.discount = calculate_user_discount(user)

def categorize_user_by_age(age: int) -> str:
    if age < 18:
        return 'minor'
    elif age >= 65:
        return 'senior'
    return 'adult'
```

### 2. Extract Class
```python
# Before
def send_email(to, subject, body, smtp_server, port, username, password):
    # Email sending logic
    pass

# After
class EmailService:
    def __init__(self, smtp_server: str, port: int, username: str, password: str):
        self.smtp_server = smtp_server
        self.port = port
        self.username = username
        self.password = password
    
    def send(self, to: str, subject: str, body: str) -> None:
        # Email sending logic
        pass

# Usage
email_service = EmailService(smtp_server, port, username, password)
email_service.send(to, subject, body)
```

### 3. Replace Conditionals with Polymorphism
```python
# Before
def calculate_shipping(order_type, weight, distance):
    if order_type == 'standard':
        return weight * 0.5 + distance * 0.1
    elif order_type == 'express':
        return weight * 1.0 + distance * 0.2
    elif order_type == 'overnight':
        return weight * 2.0 + distance * 0.5

# After
from abc import ABC, abstractmethod

class ShippingStrategy(ABC):
    @abstractmethod
    def calculate(self, weight: float, distance: float) -> float:
        pass

class StandardShipping(ShippingStrategy):
    def calculate(self, weight: float, distance: float) -> float:
        return weight * 0.5 + distance * 0.1

class ExpressShipping(ShippingStrategy):
    def calculate(self, weight: float, distance: float) -> float:
        return weight * 1.0 + distance * 0.2

class OvernightShipping(ShippingStrategy):
    def calculate(self, weight: float, distance: float) -> float:
        return weight * 2.0 + distance * 0.5

# Usage
shipping_strategies = {
    'standard': StandardShipping(),
    'express': ExpressShipping(),
    'overnight': OvernightShipping()
}

def calculate_shipping(order_type: str, weight: float, distance: float) -> float:
    strategy = shipping_strategies.get(order_type)
    if not strategy:
        raise ValueError(f"Unknown order type: {order_type}")
    return strategy.calculate(weight, distance)
```

### 4. Simplify Complex Conditionals
```python
# Before
def can_withdraw(account, amount):
    if account.balance >= amount and account.is_active and not account.is_frozen and amount > 0:
        return True
    return False

# After
def can_withdraw(account, amount):
    has_sufficient_funds = account.balance >= amount
    is_valid_amount = amount > 0
    is_account_available = account.is_active and not account.is_frozen
    
    return has_sufficient_funds and is_valid_amount and is_account_available
```

### 5. Use List Comprehensions and Generators
```python
# Before
def get_active_user_emails(users):
    emails = []
    for user in users:
        if user.is_active:
            emails.append(user.email)
    return emails

# After
def get_active_user_emails(users):
    return [user.email for user in users if user.is_active]

# For large datasets, use generator
def get_active_user_emails_generator(users):
    return (user.email for user in users if user.is_active)
```

### 6. Replace Magic Numbers with Named Constants
```python
# Before
def calculate_circle_area(radius):
    return 3.14159 * radius ** 2

def is_valid_age(age):
    return 18 <= age <= 65

# After
import math

MINIMUM_AGE = 18
RETIREMENT_AGE = 65

def calculate_circle_area(radius):
    return math.pi * radius ** 2

def is_valid_age(age):
    return MINIMUM_AGE <= age <= RETIREMENT_AGE
```

### 7. Use Type Hints
```python
# Before
def process_items(items, multiplier):
    return [item * multiplier for item in items]

# After
from typing import List, Union

def process_items(
    items: List[Union[int, float]], 
    multiplier: Union[int, float]
) -> List[Union[int, float]]:
    return [item * multiplier for item in items]
```

### 8. Replace Nested Loops with Iterator Tools
```python
# Before
def get_combinations(list1, list2):
    result = []
    for item1 in list1:
        for item2 in list2:
            result.append((item1, item2))
    return result

# After
from itertools import product

def get_combinations(list1, list2):
    return list(product(list1, list2))
```

## Code Organization Refactoring

### 1. Module Structure
```python
# Before: everything in one file
# app.py (1000+ lines)

# After: organized modules
# project/
#   ├── __init__.py
#   ├── models/
#   │   ├── __init__.py
#   │   ├── user.py
#   │   └── order.py
#   ├── services/
#   │   ├── __init__.py
#   │   ├── email_service.py
#   │   └── payment_service.py
#   └── utils/
#       ├── __init__.py
#       └── validators.py
```

### 2. Dependency Injection
```python
# Before
class OrderService:
    def process_order(self, order):
        db = Database()  # Hard-coded dependency
        payment = PaymentGateway()  # Hard-coded dependency
        # Process order

# After
class OrderService:
    def __init__(self, db: Database, payment_gateway: PaymentGateway):
        self.db = db
        self.payment_gateway = payment_gateway
    
    def process_order(self, order):
        # Process order using injected dependencies
```

## Testing During Refactoring

### 1. Maintain Test Coverage
```bash
# Run tests with coverage
pytest --cov=myproject tests/

# Generate coverage report
pytest --cov=myproject --cov-report=html tests/
```

### 2. Test Each Refactoring Step
```python
# Write characterization tests before refactoring
def test_original_behavior():
    # Capture current behavior
    result = legacy_function(test_input)
    assert result == expected_output

# Ensure behavior remains the same after refactoring
def test_refactored_behavior():
    result = refactored_function(test_input)
    assert result == expected_output
```

## Performance Considerations

### 1. Profile Before and After
```python
import cProfile
import pstats

# Profile original code
cProfile.run('original_function()', 'original_stats')

# Profile refactored code
cProfile.run('refactored_function()', 'refactored_stats')

# Compare results
original = pstats.Stats('original_stats')
refactored = pstats.Stats('refactored_stats')
```

### 2. Memory Usage
```python
from memory_profiler import profile

@profile
def function_to_refactor():
    # Your code here
    pass
```

## Refactoring Tools

### 1. Automated Refactoring with rope
```bash
pip install rope

# Use rope for automated refactoring
# - Extract method
# - Rename
# - Move
# - Inline
```

### 2. Code Formatting
```bash
# Format with black
black myproject/

# Sort imports with isort
isort myproject/

# Type check with mypy
mypy myproject/
```

## Post-Refactoring Checklist

- [ ] All tests pass
- [ ] Code coverage maintained or improved
- [ ] Performance is acceptable
- [ ] Code follows PEP 8 and project conventions
- [ ] Type hints added where appropriate
- [ ] Documentation updated
- [ ] Complex parts have explanatory comments
- [ ] No code duplication
- [ ] SOLID principles followed
- [ ] Code reviewed by team member