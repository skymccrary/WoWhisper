# GitHub Copilot MCP Quick Reference

> **TL;DR**: This repository blocks all MCPs by default. Only approved MCPs in `.github/copilot-config.json` are allowed.

## Current Policy

```
🔒 BLOCKLIST POLICY ACTIVE
All MCPs blocked except those explicitly allowed
```

## Currently Allowed MCPs

| MCP | Purpose | Status |
|-----|---------|--------|
| `github-mcp-server` | GitHub API operations | ✅ Approved |
| `playwright-browser` | Browser automation | ✅ Approved |

## Quick Actions

### Need to Add an MCP?

1. Create issue: "MCP Approval Request"
2. Fill out template with justification
3. Wait for security review
4. If approved, maintainer updates config

### Check What's Allowed

```bash
cat .github/copilot-config.json
```

### Understanding Policies

| Policy | What It Means | When to Use |
|--------|--------------|-------------|
| `blocklist` | Block all, allow specific | **Production** ✅ |
| `allowlist` | Allow all, block specific | Testing only ⚠️ |

## Common Questions

**Q: Why can't I use [MCP_NAME]?**  
A: It's not in the approved list. Request approval via issue template.

**Q: How do I request approval?**  
A: Open an issue using the "MCP Approval Request" template in `.github/ISSUE_TEMPLATE/`.

**Q: Why blocklist instead of allowlist?**  
A: Security best practice - deny by default, allow by exception.

**Q: Can I temporarily bypass this?**  
A: No. Request approval through proper channels.

**Q: How long does approval take?**  
A: 1-2 weeks for security review, faster for low-risk MCPs.

## Security Levels

| Risk Level | Approval Required | Timeline |
|------------|------------------|----------|
| 🟢 Low | Maintainer | 24-48h |
| 🟡 Medium | Maintainer | 1 week |
| 🔴 High | Security + Maintainer | 2 weeks |

## Example Use Cases

### ✅ Approved Patterns

```json
// Adding a well-known MCP
{
  "allowedMCPs": [
    "github-mcp-server",
    "playwright-browser",
    "bash"  // Newly added
  ]
}
```

### ❌ Not Recommended

```json
// Don't switch to allowlist
{
  "policy": "allowlist"  // ❌ Less secure
}
```

## Troubleshooting

### MCP Blocked Error

```
Error: MCP 'xyz' is not allowed
```

**Solution**: Check if MCP is in allowed list. If not, request approval.

### Config Not Working

1. Check JSON syntax: `python3 -m json.tool .github/copilot-config.json`
2. Restart IDE
3. Verify file is committed

## Related Documentation

- 📚 [Full Configuration Guide](.github/COPILOT_MCP_CONFIGURATION.md)
- 📋 [Configuration Examples](.github/MCP_EXAMPLES.md)
- 🔒 [Security Policy](../SECURITY.md)
- 🎫 [Request MCP Approval](.github/ISSUE_TEMPLATE/mcp-approval-request.md)

## Comparison: Cursor vs GitHub Copilot

| Feature | Cursor | GitHub Copilot |
|---------|--------|----------------|
| Configuration | UI Settings | File (`.github/copilot-config.json`) |
| Version Control | ❌ No | ✅ Yes |
| Team Sync | Manual | Automatic |
| Audit Trail | ❌ No | ✅ Git history |

## Best Practices

✅ **DO**
- Request approval before needing an MCP
- Provide detailed justification
- Document why each MCP is needed
- Review approved MCPs quarterly

❌ **DON'T**
- Try to bypass restrictions
- Use unapproved MCPs
- Switch to allowlist policy
- Add MCPs "just in case"

## Contact

Questions? Issues?
- 💬 Open a discussion
- 🐛 File an issue
- 📧 Contact repository maintainer

---

**Last Updated**: 2026-02-09  
**Config Version**: 1.0  
**Policy**: Blocklist
