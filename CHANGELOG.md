# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-07-01

### Added

#### Python Project Support
- **Auto-detection**: Automatically detects Python projects via `requirements.txt`, `pyproject.toml`, `setup.py`, or `Pipfile`
- **Framework Detection**: Identifies Django, FastAPI, Flask, or generic Python projects
- **Python-specific CLAUDE.md template**: Customized for Python development with framework-specific sections
- **CLI Options**: Added `--type=python`, `--with-django`, and `--with-fastapi` flags

#### Python Workflow Templates
- **Python Conventions** (`python/commands/conventions/python.md`): Comprehensive Python best practices including PEP 8, type hints, async patterns, and framework-specific guidelines
- **Python Testing** (`python/commands/quality/python-testing.md`): Complete pytest patterns, fixtures, mocking, async testing, and CI/CD
- **Python Debugging** (`python/commands/workflows/debug-python.md`): Systematic debugging with pdb, logging, and performance profiling
- **Python Refactoring** (`python/commands/workflows/python-refactor.md`): SOLID principles, design patterns, and code organization
- **Flask Development** (`python/commands/workflows/flask-development.md`): Complete Flask application patterns, blueprints, forms, and testing

#### Enhanced Architecture
- **ProjectConfig Class**: Language-agnostic configuration management for tools, commands, and package managers
- **Template Organization**: Restructured templates with `rails/`, `python/`, and `shared/` directories
- **Framework-specific Content**: Dynamic template content based on detected frameworks

#### Testing & Quality
- **Comprehensive Test Suite**: 41 tests covering both Rails and Python functionality
- **Framework Detection Tests**: Tests for Django, FastAPI, and Flask project detection
- **ProjectConfig Tests**: Full coverage of configuration management
- **Backward Compatibility**: All existing Rails functionality preserved

### Enhanced

#### CLI Improvements
- **Smart Project Detection**: Improved auto-detection with user prompts for unknown projects
- **Project-specific Tips**: Displays relevant setup tips after initialization
- **Doctor Command**: Enhanced health checks for both Rails and Python projects

#### Documentation
- **README**: Updated with Python examples and framework-specific usage
- **Template Structure**: Clear documentation of language-specific workflow organization

### Technical Details

#### Supported Python Frameworks
- **Django**: Detects `manage.py`, includes Django ORM patterns, management commands
- **FastAPI**: Detects FastAPI in requirements, includes async patterns, API documentation
- **Flask**: Detects Flask dependencies, includes blueprint patterns, forms, testing
- **Generic Python**: Supports any Python project with standard tooling

#### Code Quality Tools
- **Rails**: RuboCop, RSpec, Rails conventions
- **Python**: Black, flake8, mypy, pytest, type hints

## [0.1.0] - 2025-06-30

### Added
- Initial release with Rails project support
- Claude workflow initialization
- PRD and task management workflows
- Development journal system
- Migration from .cursor to .claude structure
- Rails-specific conventions and patterns