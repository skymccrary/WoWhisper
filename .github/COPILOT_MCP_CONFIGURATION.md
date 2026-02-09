# GitHub Copilot MCP Configuration Guide

## Overview

This document explains how to configure GitHub Copilot's Model Context Protocol (MCP) allow/block lists to control which MCPs can be used in your development environment.

## Problem Statement

By default, all MCPs are accessible in many development environments. However, for security and control purposes, you may want to:
- Block all MCPs by default
- Only allow explicitly approved MCPs
- Avoid relying on the MCP Registry due to its current maturity level

This is similar to the configuration available in other code editors like Cursor.

## Configuration File

The MCP configuration is managed through the `.github/copilot-config.json` file in your repository.

### Configuration Structure

```json
{
  "mcp": {
    "policy": "blocklist",
    "allowedMCPs": [
      "github-mcp-server",
      "playwright-browser"
    ],
    "blockedMCPs": []
  }
}
```

### Configuration Options

#### Policy Types

1. **`blocklist`** (Recommended for security)
   - Blocks all MCPs by default
   - Only MCPs listed in `allowedMCPs` can be used
   - Provides maximum control and security

2. **`allowlist`** (Permissive)
   - Allows all MCPs by default
   - Only MCPs listed in `blockedMCPs` are blocked
   - Less secure, not recommended for production

### Example Configurations

#### Strict Security (Recommended)

Block all MCPs and only allow specific approved ones:

```json
{
  "mcp": {
    "policy": "blocklist",
    "allowedMCPs": [
      "github-mcp-server",
      "playwright-browser",
      "bash"
    ],
    "blockedMCPs": []
  }
}
```

#### Permissive with Exceptions

Allow all MCPs except specific ones:

```json
{
  "mcp": {
    "policy": "allowlist",
    "allowedMCPs": [],
    "blockedMCPs": [
      "experimental-mcp",
      "untrusted-mcp"
    ]
  }
}
```

#### Minimal Access

Block all MCPs (most restrictive):

```json
{
  "mcp": {
    "policy": "blocklist",
    "allowedMCPs": [],
    "blockedMCPs": []
  }
}
```

## Common MCPs to Consider

Here are some commonly used MCPs you may want to allow:

| MCP Name | Purpose | Security Level |
|----------|---------|----------------|
| `github-mcp-server` | GitHub API operations | High |
| `playwright-browser` | Browser automation | Medium |
| `bash` | Shell command execution | Medium-Low |
| `web_search` | Web search capabilities | Medium |
| `code_review` | Automated code reviews | High |

## Implementation Steps

### 1. Create the Configuration File

Create `.github/copilot-config.json` in your repository root:

```bash
mkdir -p .github
touch .github/copilot-config.json
```

### 2. Set Your Policy

Edit the file with your preferred policy (blocklist recommended):

```json
{
  "mcp": {
    "policy": "blocklist",
    "allowedMCPs": [
      "github-mcp-server"
    ],
    "blockedMCPs": []
  }
}
```

### 3. Commit and Push

```bash
git add .github/copilot-config.json
git commit -m "Configure GitHub Copilot MCP restrictions"
git push
```

### 4. Verify Configuration

After pushing, verify that:
- The configuration file is in your repository
- GitHub Copilot respects the MCP restrictions
- Only allowed MCPs are accessible

## Best Practices

### Security Recommendations

1. **Use Blocklist Policy**: Always use `"policy": "blocklist"` for maximum security
2. **Minimize Allowed MCPs**: Only allow MCPs that are absolutely necessary
3. **Regular Audits**: Periodically review your `allowedMCPs` list
4. **Document Decisions**: Add comments explaining why each MCP is allowed

### Team Collaboration

1. **Centralize Configuration**: Keep the config file in your main repository
2. **Version Control**: Track all changes to MCP configurations
3. **Review Process**: Require code review for changes to `allowedMCPs`
4. **Communication**: Notify team members when MCP access changes

### Example with Documentation

```json
{
  "mcp": {
    "policy": "blocklist",
    "allowedMCPs": [
      "github-mcp-server",     // Required for GitHub operations
      "playwright-browser",    // Needed for E2E testing
      "bash"                   // Required for build scripts
    ],
    "blockedMCPs": []
  },
  "rationale": {
    "github-mcp-server": "Essential for CI/CD and issue tracking",
    "playwright-browser": "Used in automated UI tests",
    "bash": "Necessary for build and deployment automation"
  }
}
```

## Troubleshooting

### MCP Still Accessible Despite Blocklist

1. Check that your configuration file is properly formatted JSON
2. Ensure the file is in the correct location (`.github/copilot-config.json`)
3. Verify that the repository has been reloaded in your editor
4. Clear GitHub Copilot cache and restart your IDE

### Allowed MCP Not Working

1. Verify the MCP name is spelled correctly (case-sensitive)
2. Check that the MCP is available in your environment
3. Ensure the configuration has been pushed to the repository
4. Restart GitHub Copilot or your IDE

### Configuration Not Taking Effect

1. Confirm the JSON syntax is valid (use a JSON validator)
2. Check file permissions (should be readable)
3. Verify your GitHub Copilot version supports MCP configuration
4. Try explicitly reloading the workspace

## Comparison with Other Editors

### Cursor

Cursor provides a UI-based MCP configuration in settings. GitHub Copilot uses a file-based approach for better version control and team collaboration.

**Cursor Approach:**
- Settings → MCP → Block all by default → Add allowed MCPs

**GitHub Copilot Approach:**
- Configuration file in repository
- Version controlled
- Applies to entire team
- Better for CI/CD integration

## Migration from MCP Registry

If you were previously using the MCP Registry and want to avoid it:

1. Identify all MCPs currently in use
2. Create explicit `allowedMCPs` list with only those MCPs
3. Set `policy` to `blocklist`
4. Remove any MCP Registry references
5. Test thoroughly to ensure all functionality works

## Additional Resources

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Model Context Protocol Specification](https://github.com/modelcontextprotocol)
- [Security Best Practices for AI Tools](https://docs.github.com/en/copilot/using-github-copilot/responsible-use-of-github-copilot-features)

## Support

For questions or issues with MCP configuration:
- Check GitHub Copilot documentation
- Review this guide
- Contact your repository administrator
- Open an issue in this repository

## Changelog

- **2026-02-09**: Initial MCP configuration implementation with blocklist policy
