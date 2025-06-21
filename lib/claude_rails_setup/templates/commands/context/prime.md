# Context Window Prime

## Quick Context Loading

1. **Read Project Configuration**
   ```
   READ: CLAUDE.md
   ```

2. **Show Project Structure**
   ```bash
   # If eza is available
   eza . --tree --level 3 --git-ignore
   
   # Otherwise use standard ls
   ls -la
   ```

3. **Check Current Status**
   ```bash
   git status --short
   git branch --show-current
   ```

## Usage

This is a minimal context prime for when you need to quickly understand:
- Project configuration and conventions
- Directory structure
- Current git state

For more detailed context, use the `quickstart` command.