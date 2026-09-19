#!/usr/bin/env bash
set -euo pipefail

# GENX Automated Release Script
# Usage: ./release.sh <version>
# Example: ./release.sh 1.0.1 or ./release.sh v1.0.1

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.1"
    exit 1
fi

INPUT_VERSION="$1"
VERSION="${INPUT_VERSION#v}"

SEMVER_REGEX="^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-([0-9A-Za-z.-]+))?(\+([0-9A-Za-z.-]+))?$"

if [[ ! "$VERSION" =~ $SEMVER_REGEX ]]; then
    echo "❌ Error: Invalid SemVer version format: $INPUT_VERSION"
    echo "Expected SemVer format X.Y.Z (e.g. 1.0.1, 1.1.0, 2.0.0)"
    exit 1
fi

TAG_NAME="v${VERSION}"
RELEASE_DATE=$(date +%Y-%m-%d)

echo "🚀 Preparing release ${TAG_NAME} (date: ${RELEASE_DATE})..."

# 1. Check for duplicate Git tags
if git rev-parse "${TAG_NAME}" >/dev/null 2>&1; then
    echo "❌ Error: Git tag ${TAG_NAME} already exists locally."
    exit 1
fi

if git ls-remote --tags origin "${TAG_NAME}" 2>/dev/null | grep -q "${TAG_NAME}"; then
    echo "❌ Error: Git tag ${TAG_NAME} already exists on remote origin."
    exit 1
fi

# 2. Run full test suite
echo "🧪 Running full test suite..."
if command -v pytest >/dev/null 2>&1; then
    PYTHONPATH=. pytest --ignore=test_gdrive_models.py 2>/dev/null || PYTHONPATH=. pytest
else
    PYTHONPATH=. python3 -m unittest discover -s . -p "test_*.py" -v
fi

# 3. Update version files
echo "📝 Updating version files to ${VERSION}..."

echo -n "${VERSION}" > VERSION
echo -n "${VERSION}" > version.txt

python3 -c '
import re
path = "manifest.yaml"
with open(path, "r") as f:
    content = f.read()
content = re.sub(r"genx_platform:\s*\"[^\"]*\"", f"genx_platform: \"${VERSION}\"", content)
content = re.sub(r"release_status:\s*\"[^\"]*\"", "release_status: \"stable\"", content)
content = re.sub(r"release_date:\s*\"[^\"]*\"", f"release_date: \"${RELEASE_DATE}\"", content)
with open(path, "w") as f:
    f.write(content)
'

if [ -f package.json ]; then
    python3 -c '
import json
with open("package.json", "r") as f:
    d = json.load(f)
d["version"] = "${VERSION}"
with open("package.json", "w") as f:
    json.dump(d, f, indent=2)
    f.write("\n")
'
fi

# 4. Update CHANGELOG.md
if [ -f CHANGELOG.md ]; then
    if ! grep -q "\[${VERSION}\]" CHANGELOG.md && ! grep -q "\[v${VERSION}\]" CHANGELOG.md; then
        echo "Updating CHANGELOG.md with entry for ${VERSION}..."
        python3 -c '
with open("CHANGELOG.md", "r") as f:
    lines = f.readlines()
new_lines = []
inserted = False
for line in lines:
    new_lines.append(line)
    if "## [Unreleased]" in line and not inserted:
        new_lines.append("\n")
        new_lines.append(f"## [${VERSION}] - ${RELEASE_DATE}\n")
        new_lines.append("\n")
        new_lines.append(f"### Release v${VERSION}\n")
        new_lines.append(f"- Platform update to version ${VERSION}.\n")
        inserted = True
with open("CHANGELOG.md", "w") as f:
    f.writelines(new_lines)
'
    fi
fi

# 5. Run version validation script
echo "🔍 Validating version consistency..."
python3 scripts/validate_version.py

# 6. Git commit & tag
echo "📦 Creating Git commit and annotated tag ${TAG_NAME}..."
git add VERSION version.txt manifest.yaml CHANGELOG.md
if [ -f package.json ]; then
    git add package.json
fi

git commit -m "chore(release): release ${TAG_NAME}"
git tag -a "${TAG_NAME}" -m "Release ${TAG_NAME}"

# 7. Push commit and tag if remote origin exists
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if git remote | grep -q "origin"; then
    echo "⬆️ Pushing release commit and tag to origin..."
    if git push origin "${CURRENT_BRANCH}" && git push origin "${TAG_NAME}"; then
        echo "✅ Release ${TAG_NAME} pushed successfully!"
    else
        echo "⚠️ Warning: Failed to push to remote origin. Release tag ${TAG_NAME} created locally."
    fi
else
    echo "ℹ️ No remote origin configured. Release commit and tag ${TAG_NAME} created locally."
fi

echo "🎉 Release ${TAG_NAME} created successfully!"
