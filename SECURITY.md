# Security Policy

## GitHub Copilot MCP Security

This repository implements strict Model Context Protocol (MCP) controls for GitHub Copilot to ensure secure development practices.

### MCP Security Model

We use a **blocklist policy** where:
- ✅ All MCPs are blocked by default
- ✅ Only explicitly approved MCPs are allowed
- ✅ MCP approvals require security review
- ✅ Configuration is version-controlled

### Current Approved MCPs

The current list of approved MCPs can be found in `.github/copilot-config.json`.

As of the latest update, we allow:
- `github-mcp-server` - Official GitHub operations MCP
- `playwright-browser` - Browser automation for testing

### Security Principles

1. **Principle of Least Privilege**: Only grant access to MCPs that are absolutely necessary
2. **Defense in Depth**: Multiple layers of security controls
3. **Audit Trail**: All MCP changes are tracked in git history
4. **Regular Review**: Quarterly audits of approved MCPs

### Requesting MCP Approval

To request a new MCP be added to the allowed list:

1. Open an issue using the "MCP Approval Request" template
2. Provide detailed justification and security assessment
3. Wait for security team review
4. Address any concerns raised
5. Approval requires sign-off from a repository maintainer

### Security Considerations for MCPs

When evaluating MCPs, consider:

#### Data Access
- What repository data can the MCP access?
- Does it read sensitive files?
- Can it access credentials or secrets?

#### Network Access
- Does the MCP make external API calls?
- Where does data get sent?
- Is data transmitted securely (HTTPS)?

#### Code Execution
- Can the MCP execute arbitrary code?
- What permissions does it require?
- Is it sandboxed or isolated?

#### Trust & Provenance
- Is the MCP from a trusted source?
- Is it actively maintained?
- Has it been security audited?
- What is the community reputation?

### Blocked MCP Categories

The following types of MCPs are generally not approved:

- ❌ MCPs from untrusted sources
- ❌ MCPs that require excessive permissions
- ❌ MCPs that transmit code to untrusted third parties
- ❌ MCPs with known security vulnerabilities
- ❌ Unmaintained or abandoned MCPs
- ❌ MCPs without clear documentation

### Incident Response

If you discover a security issue with an approved MCP:

1. **Immediately**: Stop using the MCP
2. **Report**: Create a private security advisory (not a public issue)
3. **Document**: Note what sensitive data may have been exposed
4. **Remediate**: Remove the MCP from `allowedMCPs` if necessary
5. **Review**: Assess impact and implement preventive measures

### Reporting Security Vulnerabilities

To report a security vulnerability:

1. **Do NOT** open a public issue
2. Use GitHub's private security advisory feature
3. Or email the maintainer directly
4. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested remediation

### Security Updates

We commit to:
- Reviewing MCP security monthly
- Responding to security reports within 48 hours
- Publishing security advisories for critical issues
- Updating documentation when threats are identified

### Compliance

This MCP security policy helps ensure compliance with:
- Organization security policies
- Data protection regulations
- Industry best practices
- Secure software development lifecycle (SSDLC)

### Security Review Process

All MCP approval requests undergo:

1. **Initial Review** (24-48 hours)
   - Validate use case
   - Check MCP source
   - Preliminary security assessment

2. **Security Analysis** (1-2 weeks)
   - Review MCP source code (if available)
   - Test in isolated environment
   - Assess data access patterns
   - Check for known vulnerabilities

3. **Risk Assessment**
   - Document potential risks
   - Evaluate mitigations
   - Determine risk level (low/medium/high)

4. **Approval Decision**
   - Low risk: Auto-approve
   - Medium risk: Requires maintainer approval
   - High risk: Requires security team + maintainer approval

### Best Practices for Developers

When using approved MCPs:

- ✅ Only use MCPs for their intended purpose
- ✅ Be cautious with sensitive data
- ✅ Review MCP actions before accepting
- ✅ Report unexpected behavior
- ✅ Keep MCPs updated
- ❌ Don't circumvent MCP restrictions
- ❌ Don't share credentials with MCPs
- ❌ Don't use MCPs in production environments without approval

### Monitoring & Auditing

We monitor MCP usage through:
- Git commit history for configuration changes
- Regular security audits
- Community feedback
- Vulnerability scanning

### Additional Resources

- [GitHub Copilot Security Best Practices](https://docs.github.com/en/copilot/using-github-copilot/responsible-use-of-github-copilot-features)
- [MCP Configuration Guide](.github/COPILOT_MCP_CONFIGURATION.md)
- [MCP Examples](.github/MCP_EXAMPLES.md)

### Version History

- **2026-02-09**: Initial security policy and blocklist implementation
  - Implemented blocklist policy
  - Added `github-mcp-server` and `playwright-browser` to approved list
  - Created MCP approval process

---

**Last Updated**: 2026-02-09  
**Policy Version**: 1.0  
**Next Review**: 2026-05-09
