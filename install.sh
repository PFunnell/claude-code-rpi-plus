#!/bin/bash
#
# Claude Code RPI Plus Installer (Unix)
#
# Installs the RPI Plus pack to a target project directory.
#
# Usage:
#   ./install.sh [target_directory]
#
# Examples:
#   ./install.sh                    # Install to current directory
#   ./install.sh /path/to/project   # Install to specific directory

set -e

PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    echo "Error: Target directory does not exist: $1"
    exit 1
}

echo "Claude Code RPI Plus Installer"
echo "==============================="
echo ""
echo "Pack source: $PACK_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Check if .claude already exists
if [ -d "$TARGET_DIR/.claude" ]; then
    echo "WARNING: .claude/ directory already exists"
    read -p "Merge with existing? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "Aborted."
        exit 1
    fi
    echo ""
fi

# Copy core files
echo "Installing core configuration..."
cp -r "$PACK_DIR/.claude" "$TARGET_DIR/"
echo "  - .claude/ directory"

# Copy scripts
echo "Installing scripts..."
mkdir -p "$TARGET_DIR/scripts"
cp "$PACK_DIR/scripts/validate-artefacts.py" "$TARGET_DIR/scripts/"
cp "$PACK_DIR/scripts/cc-transcript.sh" "$TARGET_DIR/scripts/"
cp "$PACK_DIR/scripts/cc-transcript.ps1" "$TARGET_DIR/scripts/"
echo "  - scripts/validate-artefacts.py"
echo "  - scripts/cc-transcript.sh"
echo "  - scripts/cc-transcript.ps1"

# Make scripts executable
chmod +x "$TARGET_DIR/scripts/cc-transcript.sh"

# Create artefact directories
echo "Creating artefact directories..."
mkdir -p "$TARGET_DIR/docs/plans"
mkdir -p "$TARGET_DIR/docs/research"
mkdir -p "$TARGET_DIR/docs/state"
mkdir -p "$TARGET_DIR/docs/verification"
echo "  - docs/plans/"
echo "  - docs/research/"
echo "  - docs/state/"
echo "  - docs/verification/"

# Copy templates
echo "Copying templates..."
if [ -d "$PACK_DIR/templates" ]; then
    cp "$PACK_DIR/templates/CLAUDE.md.template" "$TARGET_DIR/" 2>/dev/null || true
    cp "$PACK_DIR/templates/gitignore.additions" "$TARGET_DIR/" 2>/dev/null || true
fi

# Create local config from example
if [ ! -f "$TARGET_DIR/.claude/portable_config.local.yaml" ]; then
    cp "$TARGET_DIR/.claude/portable_config.local.example.yaml" \
       "$TARGET_DIR/.claude/portable_config.local.yaml"
    echo "  - Created portable_config.local.yaml from example"
fi

# Append to .gitignore if it exists
if [ -f "$TARGET_DIR/.gitignore" ] && [ -f "$TARGET_DIR/gitignore.additions" ]; then
    echo "" >> "$TARGET_DIR/.gitignore"
    cat "$TARGET_DIR/gitignore.additions" >> "$TARGET_DIR/.gitignore"
    rm "$TARGET_DIR/gitignore.additions"
    echo "  - Updated .gitignore"
elif [ -f "$TARGET_DIR/gitignore.additions" ]; then
    mv "$TARGET_DIR/gitignore.additions" "$TARGET_DIR/.gitignore"
    echo "  - Created .gitignore"
fi

echo ""
echo "Installation complete!"
echo ""
echo "PREREQUISITE: Run /init first (if not already done)"
echo "==================================================="
echo ""
echo "If you haven't run /init yet:"
echo "  cd $TARGET_DIR && claude"
echo "  > /init"
echo ""
echo "NEXT STEP - use this prompt in Claude Code:"
echo "============================================"
echo ""
echo 'Merge the workflow section from CLAUDE.md.template into the existing CLAUDE.md.'
echo 'Then configure .claude/portable_config.local.yaml with the project name and test command.'
echo 'Finally, run /phase_complete to verify setup and delete CLAUDE.md.template.'
echo ""
