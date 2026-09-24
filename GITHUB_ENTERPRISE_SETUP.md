# GitHub Enterprise Setup Guide

## Overview

This guide details the setup, configuration, and integration procedures for connecting the **NUNA / GenX FX** repository with **GitHub Enterprise Cloud**:

- **Enterprise URL**: `https://github.com/enterprises/lenga6-9v-5g`
- **Enterprise Account Slug**: `lenga6-9v-5g`
- **Primary Integration Date**: 2026-03-01

---

## Configuration & Architecture

The GitHub Enterprise setup provides centralized policy management, SAML SSO authentication, security scanning, fine-grained access control, and enterprise runner orchestration across all organizational repositories under `lenga6-9v-5g`.

### Quick Reference Table

| Component | Setting / Location |
|-----------|--------------------|
| Enterprise URL | `https://github.com/enterprises/lenga6-9v-5g` |
| Enterprise Slug | `lenga6-9v-5g` |
| Setup Helper (Linux/Mac) | `scripts/setup-github-enterprise.sh` |
| Setup Helper (Windows) | `scripts/setup-github-enterprise.ps1` |
| Environment Config | `.env.example`, `.env.secrets.example` |
| System Registry | `system-info.json` |

---

## Step-by-step Setup Instructions

### 1. Authentication & SAML SSO

When accessing resources in enterprise `lenga6-9v-5g`:
1. Ensure your personal access token (PAT) or SSH key is authorized for SAML Single Sign-On (SSO).
2. Authorize token for enterprise `lenga6-9v-5g` via:
   `https://github.com/enterprises/lenga6-9v-5g/sso`
3. Export token in environment:
   ```bash
   export GITHUB_ENTERPRISE_TOKEN=your_pat_token_here
   export GITHUB_ENTERPRISE_URL=https://github.com/enterprises/lenga6-9v-5g
   ```

### 2. Git Remote Setup

To configure local Git remote for enterprise repository:

```bash
# Automated via helper script:
./scripts/setup-github-enterprise.sh

# Or manually:
git remote add enterprise https://github.com/enterprises/lenga6-9v-5g/NUNA.git
# Or set origin URL with token:
git remote set-url origin https://${GITHUB_ENTERPRISE_TOKEN}@github.com/enterprises/lenga6-9v-5g/NUNA.git
```

Windows PowerShell:
```powershell
.\scripts\setup-github-enterprise.ps1
```

### 3. Enterprise GitHub Actions & Security Policies

Under enterprise `lenga6-9v-5g`:
- **Secret Scanning**: Enabled across all organizations and repositories.
- **Dependabot**: Version and security updates enabled.
- **Code Security & Analysis**: CodeQL and automated vulnerability alerts.
- **Self-Hosted Runners**: Enterprise runner groups managed under `lenga6-9v-5g`.

---

## Verification & Troubleshooting

### Verification

Run the enterprise setup verification script:
```bash
./scripts/setup-github-enterprise.sh --verify
```
Or check system info:
```bash
./scripts/setup-github-enterprise.sh --verify
```

### Common Issues

1. **SAML SSO Authorization Error**:
   If Git push/pull operations return `403 Forbidden` or `SAML enforcement enabled`:
   - Visit `https://github.com/enterprises/lenga6-9v-5g`
   - Click "Authorize SSO" next to your token/key.

2. **Enterprise Remote Unreachable**:
   - Verify network connection and DNS resolution.
   - Verify PAT has required `repo`, `admin:org`, and `workflow` scopes.

---

**Last Updated**: 2026-03-01
**Status**: Active & Configured
