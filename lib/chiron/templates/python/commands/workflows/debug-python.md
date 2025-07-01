# Python Debugging Workflow

When debugging Python code, follow this systematic approach to identify and resolve issues efficiently.

## Debugging Strategy

### 1. Understand the Error
- Read the full traceback from bottom to top
- Identify the exact line where the error occurred
- Note the exception type and message
- Check if it's a syntax error, runtime error, or logic error

### 2. Use Print Debugging
```python
# Quick debugging with print
print(f"DEBUG: variable_name = {variable_name}")
print(f"DEBUG: type = {type(variable_name)}")
print(f"DEBUG: {locals()=}")  # Python 3.8+

# Pretty print complex objects
from pprint import pprint
pprint(complex_object)
```

### 3. Python Debugger (pdb)
```python
# Insert breakpoint in code
import pdb; pdb.set_trace()  # Traditional way
breakpoint()  # Python 3.7+

# Common pdb commands:
# n - next line
# s - step into function
# c - continue
# l - list code
# p variable - print variable
# pp variable - pretty print
# h - help
```

### 4. IDE Debugging
- Set breakpoints by clicking on line numbers
- Use conditional breakpoints for specific cases
- Watch variables in the debugger panel
- Step through code line by line

### 5. Logging for Production
```python
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Use different log levels
logger.debug("Detailed information for debugging")
logger.info("General information")
logger.warning("Warning messages")
logger.error("Error messages")
logger.exception("Error with traceback")
```

## Common Python Issues

### 1. Import Errors
```python
# Check Python path
import sys
print(sys.path)

# Check module location
import module_name
print(module_name.__file__)
```

### 2. Type Errors
```python
# Check types before operations
if isinstance(variable, expected_type):
    # Safe to proceed
    
# Use type hints for clarity
from typing import List, Dict, Optional

def process_data(items: List[str]) -> Dict[str, int]:
    return {item: len(item) for item in items}
```

### 3. Async Debugging
```python
# Debug async code
import asyncio

async def debug_async():
    print(f"Current task: {asyncio.current_task()}")
    print(f"All tasks: {asyncio.all_tasks()}")
    
# Enable asyncio debug mode
asyncio.run(main(), debug=True)
```

### 4. Memory Issues
```python
# Check memory usage
import sys
print(f"Size of object: {sys.getsizeof(object)} bytes")

# Profile memory
from memory_profiler import profile

@profile
def memory_intensive_function():
    # Your code here
```

## Testing for Debugging

### 1. Write Minimal Test Case
```python
def test_specific_issue():
    # Isolate the problem
    result = function_under_test(specific_input)
    assert result == expected_output
```

### 2. Use pytest with verbose output
```bash
pytest -vv test_file.py::test_specific_issue
pytest --pdb  # Drop into debugger on failure
pytest --pdb-trace  # Drop into debugger at start of test
```

### 3. Mock External Dependencies
```python
from unittest.mock import Mock, patch

@patch('module.external_service')
def test_with_mock(mock_service):
    mock_service.return_value = "expected_response"
    # Test your code without external dependencies
```

## Performance Debugging

### 1. Time Execution
```python
import time

start = time.time()
# Code to measure
end = time.time()
print(f"Execution time: {end - start:.4f} seconds")

# Or use context manager
from contextlib import contextmanager

@contextmanager
def timer():
    start = time.time()
    yield
    print(f"Execution time: {time.time() - start:.4f} seconds")

with timer():
    # Code to measure
```

### 2. Profile Code
```python
import cProfile
import pstats

# Profile function
cProfile.run('function_to_profile()', 'profile_stats')

# Analyze results
stats = pstats.Stats('profile_stats')
stats.sort_stats('cumulative')
stats.print_stats(10)  # Top 10 functions
```

## Framework-Specific Debugging

### Django
```python
# Django shell for interactive debugging
python manage.py shell

# Django debug toolbar
# Install: pip install django-debug-toolbar
# Add to INSTALLED_APPS and MIDDLEWARE

# SQL query debugging
from django.db import connection
print(connection.queries)
```

### FastAPI
```python
# Enable debug mode
app = FastAPI(debug=True)

# Log requests
@app.middleware("http")
async def log_requests(request: Request, call_next):
    logger.info(f"Request: {request.method} {request.url}")
    response = await call_next(request)
    return response
```

## Debug Checklist

- [ ] Read the full error message and traceback
- [ ] Identify the exact line causing the issue
- [ ] Check variable types and values at the error point
- [ ] Verify function inputs and outputs
- [ ] Test with minimal reproducible example
- [ ] Check for common issues (None values, empty lists, type mismatches)
- [ ] Use appropriate debugging tools (print, pdb, logging)
- [ ] Write a test to prevent regression
- [ ] Document the solution for future reference