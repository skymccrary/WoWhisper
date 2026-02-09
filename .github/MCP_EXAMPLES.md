# GitHub Copilot MCP Configuration Examples

This directory contains example configurations for GitHub Copilot MCP (Model Context Protocol) restrictions.

## Files

- `copilot-config.json` - Active configuration (blocklist policy with approved MCPs)
- `examples/` - Example configurations for different use cases

## Quick Reference

### Current Configuration

The repository uses a **blocklist policy** that:
- Blocks all MCPs by default
- Only allows explicitly approved MCPs
- Provides maximum security and control

### Modifying the Configuration

1. Edit `.github/copilot-config.json`
2. Add or remove MCPs from the `allowedMCPs` array
3. Commit and push your changes
4. Restart your IDE to apply changes

### Available Policies

| Policy | Behavior | Security Level | Use Case |
|--------|----------|----------------|----------|
| `blocklist` | Block all, allow specific | High | Production, secure environments |
| `allowlist` | Allow all, block specific | Low | Development, testing |

## Example Configurations

### Strict Security (Current)

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

### Development Environment

```json
{
  "mcp": {
    "policy": "blocklist",
    "allowedMCPs": [
      "github-mcp-server",
      "playwright-browser",
      "bash",
      "web_search",
      "code_review"
    ],
    "blockedMCPs": []
  }
}
```

### Maximum Restriction

```json
{
  "mcp": {
    "policy": "blocklist",
    "allowedMCPs": [],
    "blockedMCPs": []
  }
}
```

### Permissive (Not Recommended)

```json
{
  "mcp": {
    "policy": "allowlist",
    "allowedMCPs": [],
    "blockedMCPs": [
      "untrusted-mcp"
    ]
  }
}
```

## Common MCP Selections

### Minimal (GitHub Only)
- `github-mcp-server` - For GitHub operations

### Standard Development
- `github-mcp-server` - GitHub operations
- `bash` - Shell commands
- `code_review` - Automated reviews

### Full Development
- `github-mcp-server` - GitHub operations
- `playwright-browser` - Browser automation
- `bash` - Shell commands
- `web_search` - Web searches
- `code_review` - Automated reviews

### CI/CD Environment
- `github-mcp-server` - GitHub operations
- `bash` - Build scripts
- `code_review` - Pre-merge reviews

## Comparison with Cursor

Cursor provides UI-based MCP configuration, while GitHub Copilot uses file-based configuration.

### Advantages of File-Based Config (GitHub Copilot)
✅ Version controlled
✅ Team-wide consistency
✅ CI/CD integration
✅ Audit trail
✅ Easy to review changes

### Cursor UI Approach
- Settings → MCP → "Block all MCPs by default"
- Manually add allowed MCPs in UI

### GitHub Copilot File Approach
- Edit `.github/copilot-config.json`
- Commit to version control
- Automatic team-wide deployment

## Best Practices

1. **Start Restrictive**: Begin with blocklist policy and minimal MCPs
2. **Add as Needed**: Only add MCPs when you have a specific use case
3. **Document Reasons**: Comment why each MCP is allowed
4. **Regular Review**: Audit allowed MCPs quarterly
5. **Team Alignment**: Discuss MCP changes in code reviews

## Troubleshooting

### Configuration Not Applied
- Ensure file is valid JSON
- Restart your IDE
- Check file is committed to repository

### MCP Still Blocked
- Verify MCP name spelling (case-sensitive)
- Check `allowedMCPs` array
- Confirm policy is `blocklist`

### Need to Temporarily Allow MCP
1. Add MCP to `allowedMCPs`
2. Commit with explanation
3. Remove after use if temporary

## Resources

- [Full Documentation](./COPILOT_MCP_CONFIGURATION.md)
- [GitHub Copilot Docs](https://docs.github.com/en/copilot)
- [MCP Specification](https://github.com/modelcontextprotocol)
