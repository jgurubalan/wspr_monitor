#!/usr/bin/env bash

set -e

# ============================================================
# Local Lightning Monitor - Project Setup
# ============================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo
echo "=============================================="
echo " Local Lightning Monitor - Setup"
echo "=============================================="
echo
echo "Project directory:"
echo "  $PROJECT_DIR"
echo

# ------------------------------------------------------------
# 1. Check Python
# ------------------------------------------------------------

if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: python3 is not installed."
    echo
    echo "Install Python 3 first."
    exit 1
fi

echo "Python:"
python3 --version

# ------------------------------------------------------------
# 2. Create virtual environment
# ------------------------------------------------------------

VENV_DIR="$PROJECT_DIR/.venv"
VENV_PYTHON="$VENV_DIR/bin/python"
VENV_PIP="$VENV_DIR/bin/pip"

if [ ! -d "$VENV_DIR" ]; then
    echo
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    echo "Virtual environment created."
else
    echo
    echo "Virtual environment already exists."
fi

# ------------------------------------------------------------
# 3. Verify virtual environment
# ------------------------------------------------------------

if [ ! -x "$VENV_PYTHON" ]; then
    echo
    echo "ERROR: Virtual environment Python was not found:"
    echo "  $VENV_PYTHON"
    exit 1
fi

echo
echo "Virtual environment Python:"
"$VENV_PYTHON" --version

# ------------------------------------------------------------
# 4. Check pip inside virtual environment
# ------------------------------------------------------------

if [ ! -x "$VENV_PIP" ]; then
    echo
    echo "ERROR: pip was not found in the virtual environment."
    echo
    echo "Try:"
    echo "  python3 -m ensurepip --upgrade"
    exit 1
fi

echo
echo "Virtual environment pip:"
"$VENV_PIP" --version

# ------------------------------------------------------------
# 5. Upgrade pip if necessary
# ------------------------------------------------------------

echo
echo "Checking pip..."

"$VENV_PYTHON" -m pip install --upgrade pip

# ------------------------------------------------------------
# 6. Install requirements
# ------------------------------------------------------------

REQUIREMENTS="$PROJECT_DIR/requirements.txt"

if [ -f "$REQUIREMENTS" ]; then

    echo
    echo "=============================================="
    echo " Checking Python packages"
    echo "=============================================="
    echo
    echo "Requirements file:"
    echo "  $REQUIREMENTS"
    echo

    "$VENV_PYTHON" -m pip install -r "$REQUIREMENTS"

    echo
    echo "Python package installation/check complete."

else

    echo
    echo "WARNING: requirements.txt was not found:"
    echo "  $REQUIREMENTS"
    echo
fi

# ------------------------------------------------------------
# 7. Verify installed packages
# ------------------------------------------------------------

if [ -f "$REQUIREMENTS" ]; then

    echo
    echo "Verifying installed packages..."

    "$VENV_PYTHON" -m pip check

    echo
    echo "Package verification successful."

fi

# ------------------------------------------------------------
# 8. Configure VS Code
# ------------------------------------------------------------

VSCODE_DIR="$PROJECT_DIR/.vscode"
VSCODE_SETTINGS="$VSCODE_DIR/settings.json"

mkdir -p "$VSCODE_DIR"

echo
echo "Configuring VS Code..."

cat > "$VSCODE_SETTINGS" <<EOF
{
    "python.defaultInterpreterPath": "\${workspaceFolder}/.venv/bin/python",
    "python.terminal.activateEnvironment": true
}
EOF

echo "VS Code configuration created:"
echo "  $VSCODE_SETTINGS"

# ------------------------------------------------------------
# 9. Check VS Code command
# ------------------------------------------------------------

echo

if command -v code >/dev/null 2>&1; then
    echo "VS Code:"
    echo "  $(command -v code)"

    echo
    echo "Opening project in VS Code..."

    code "$PROJECT_DIR"

else

    echo "WARNING: 'code' command was not found."
    echo
    echo "VS Code configuration has still been created."
    echo "Open the project manually in VS Code:"
    echo
    echo "  $PROJECT_DIR"
fi

# ------------------------------------------------------------
# 10. Finished
# ------------------------------------------------------------

echo
echo "=============================================="
echo " Setup complete"
echo "=============================================="
echo
echo "Virtual environment:"
echo "  $VENV_DIR"
echo
echo "Python:"
echo "  $VENV_PYTHON"
echo
echo "VS Code interpreter:"
echo "  .venv/bin/python"
echo
echo "To activate the environment manually:"
echo
echo "  source .venv/bin/activate"
echo