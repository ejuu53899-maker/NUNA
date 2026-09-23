#!/usr/bin/env bash

# GitHub Enterprise lenga6-9v-5g Setup Script
# Configures and verifies GitHub Enterprise Cloud integration

set -e

ENTERPRISE_SLUG="lenga6-9v-5g"
ENTERPRISE_URL="https://github.com/enterprises/lenga6-9v-5g"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}   GitHub Enterprise (${ENTERPRISE_SLUG}) Setup Helper  ${NC}"
echo -e "${BLUE}====================================================${NC}"

if [ "$1" == "--verify" ]; then
    echo -e "${BLUE}Verifying GitHub Enterprise configuration...${NC}"
    if grep -q "${ENTERPRISE_URL}" system-info.json 2>/dev/null; then
        echo -e "${GREEN}✓ system-info.json contains Enterprise URL: ${ENTERPRISE_URL}${NC}"
    fi
    if git remote -v | grep -q "${ENTERPRISE_SLUG}"; then
        echo -e "${GREEN}✓ Git remote contains enterprise endpoint.${NC}"
    else
        echo -e "${YELLOW}! Enterprise remote not added yet to git remotes.${NC}"
    fi
else
    echo -e "${BLUE}Configuring GitHub Enterprise endpoint: ${ENTERPRISE_URL}${NC}"

    if git remote | grep -q "^enterprise$"; then
        echo -e "${YELLOW}Remote 'enterprise' already exists. Updating URL...${NC}"
        git remote set-url enterprise "${ENTERPRISE_URL}/NUNA.git"
    else
        echo -e "${BLUE}Adding remote 'enterprise'...${NC}"
        git remote add enterprise "${ENTERPRISE_URL}/NUNA.git" || true
    fi

    echo -e "${GREEN}✓ Enterprise remote configured:${NC}"
    echo "  Enterprise URL:  ${ENTERPRISE_URL}"
    echo "  Enterprise Slug: ${ENTERPRISE_SLUG}"
    echo -e "${GREEN}Setup completed successfully!${NC}"
fi
