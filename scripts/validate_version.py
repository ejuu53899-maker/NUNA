#!/usr/bin/env python3
"""
GENX Version Validation Script.
Validates SemVer compliance, version file consistency across the repository,
and checks for required changelog entries and component version definitions.
"""

import os
import re
import sys
import json

try:
    import yaml
except ImportError:
    yaml = None

SEMVER_REGEX = r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'

def is_valid_semver(version_str: str) -> bool:
    if not version_str or not isinstance(version_str, str):
        return False
    return bool(re.match(SEMVER_REGEX, version_str.strip()))

def parse_simple_yaml(content: str) -> dict:
    """Fallback simple YAML parser for key-value and nested components if PyYAML is not installed."""
    data = {}
    current_section = None
    for line in content.splitlines():
        line_strip = line.strip()
        if not line_strip or line_strip.startswith('#'):
            continue
        if ':' in line:
            if line.startswith(' ') or line.startswith('\t'):
                key, val = line.split(':', 1)
                key = key.strip()
                val = val.strip().strip('"\'')
                if current_section and isinstance(data.get(current_section), dict):
                    data[current_section][key] = val
            else:
                key, val = line.split(':', 1)
                key = key.strip()
                val = val.strip().strip('"\'')
                if val == '':
                    current_section = key
                    data[key] = {}
                else:
                    current_section = None
                    data[key] = val
    return data

def validate_version_consistency(repo_root: str = ".") -> bool:
    errors = []

    version_file = os.path.join(repo_root, "VERSION")
    version_txt = os.path.join(repo_root, "version.txt")
    manifest_file = os.path.join(repo_root, "manifest.yaml")
    package_json = os.path.join(repo_root, "package.json")
    changelog_file = os.path.join(repo_root, "CHANGELOG.md")

    # 1. Validate VERSION
    main_version = None
    if not os.path.exists(version_file):
        errors.append("Missing required file: VERSION")
    else:
        with open(version_file, "r", encoding="utf-8") as f:
            main_version = f.read().strip()
        if not is_valid_semver(main_version):
            errors.append(f"VERSION file value '{main_version}' is not valid SemVer (expected format X.Y.Z).")

    # 2. Validate version.txt
    if not os.path.exists(version_txt):
        errors.append("Missing required file: version.txt")
    else:
        with open(version_txt, "r", encoding="utf-8") as f:
            v_txt = f.read().strip()
        if not is_valid_semver(v_txt):
            errors.append(f"version.txt value '{v_txt}' is not valid SemVer.")
        if main_version and v_txt != main_version:
            errors.append(f"Inconsistency: VERSION ({main_version}) != version.txt ({v_txt})")

    # 3. Validate manifest.yaml
    if not os.path.exists(manifest_file):
        errors.append("Missing required file: manifest.yaml")
    else:
        with open(manifest_file, "r", encoding="utf-8") as f:
            manifest_raw = f.read()
        if yaml:
            manifest_data = yaml.safe_load(manifest_raw)
        else:
            manifest_data = parse_simple_yaml(manifest_raw)

        if not isinstance(manifest_data, dict):
            errors.append("manifest.yaml must contain valid YAML dictionary structure.")
        else:
            m_genx = str(manifest_data.get("genx_platform", ""))
            if not is_valid_semver(m_genx):
                errors.append(f"manifest.yaml genx_platform '{m_genx}' is not valid SemVer.")
            if main_version and m_genx != main_version:
                errors.append(f"Inconsistency: VERSION ({main_version}) != manifest.yaml genx_platform ({m_genx})")

            # Validate component versions & metadata fields
            status = manifest_data.get("release_status")
            if not status:
                errors.append("manifest.yaml missing 'release_status'")

            r_date = manifest_data.get("release_date")
            if not r_date:
                errors.append("manifest.yaml missing 'release_date'")

            components = manifest_data.get("components", {})
            if not isinstance(components, dict):
                errors.append("manifest.yaml 'components' must be a mapping dictionary.")
            else:
                for comp_name in ["genx_fx", "skill_manager", "mt5_bridge", "trading_strategy"]:
                    if comp_name not in components:
                        errors.append(f"manifest.yaml missing component version for '{comp_name}'")

    # 4. Validate package.json
    if os.path.exists(package_json):
        try:
            with open(package_json, "r", encoding="utf-8") as f:
                pkg = json.load(f)
            pkg_v = pkg.get("version")
            if main_version and pkg_v != main_version:
                errors.append(f"Inconsistency: VERSION ({main_version}) != package.json version ({pkg_v})")
        except Exception as e:
            errors.append(f"Failed to read/parse package.json: {e}")

    # 5. Validate CHANGELOG.md
    if not os.path.exists(changelog_file):
        errors.append("Missing required file: CHANGELOG.md")
    elif main_version:
        with open(changelog_file, "r", encoding="utf-8") as f:
            clog = f.read()
        expected_patterns = [f"[{main_version}]", f"[v{main_version}]", f"## {main_version}", f"## v{main_version}"]
        if not any(pattern in clog for pattern in expected_patterns):
            errors.append(f"CHANGELOG.md does not contain entry header for version [{main_version}]")

    if errors:
        print("❌ GENX Version Validation Failed:")
        for err in errors:
            print(f"  • {err}")
        return False

    print(f"✅ GENX Version Validation Passed! Main Platform Version: {main_version}")
    return True

if __name__ == "__main__":
    root_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    success = validate_version_consistency(root_dir)
    sys.exit(0 if success else 1)
