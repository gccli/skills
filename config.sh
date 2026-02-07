#! /bin/bash

# Get current date and time for backup filename
dt=$(date +'%Y%m%d%H%m%S')

# Define paths
OPENDOC_CONFIG_DIR="$HOME/.config/opencode"
OPENDOC_CONFIG_FILE="$OPENDOC_CONFIG_DIR/config.json"
GLOBAL_CONFIG_FILE="config.global.json"

echo "Starting OpenCode configuration script..."

# 1. Create ~/.config/opencode directory if it doesn't exist
if [ ! -d "$OPENDOC_CONFIG_DIR" ]; then
    echo "Creating directory: $OPENDOC_CONFIG_DIR"
    mkdir -p "$OPENDOC_CONFIG_DIR"
fi

# 2. Compare with global config and prompt user
if [ -f "$OPENDOC_CONFIG_FILE" ]; then
    # Check if there are any differences
    if diff -q "$OPENDOC_CONFIG_FILE" "$GLOBAL_CONFIG_FILE" >/dev/null; then
        echo "Your current config is identical to the global config. No update needed."
        exit 0
    else
        # Backup existing config if it exists and there are differences
        echo "Backing up existing config to: ${OPENDOC_CONFIG_FILE}.${dt}"
        /bin/cp "$OPENDOC_CONFIG_FILE" "${OPENDOC_CONFIG_FILE}.${dt}"

        echo "Differences between your current config and the global config:"
        # `|| true` prevents the script from exiting if diff finds differences
        diff -u "$OPENDOC_CONFIG_FILE" "$GLOBAL_CONFIG_FILE" || true

        read -p "Overwrite your existing config with the global config? (y/N) " -n 1 -r
        echo # Move to a new line after the prompt
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Configuration not updated. Keeping existing config."
            exit 0
        fi
    fi
fi
echo "Differences between your current config and the global config:"

diff -u "$OPENDOC_CONFIG_FILE" "$GLOBAL_CONFIG_FILE" || true

read -p "Overwrite your existing config with the global config? (y/N) " -n 1 -r
echo # Move to a new line after the prompt
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Configuration not updated. Keeping existing config."
    exit 0
fi

# 4. Copy global config to user config
echo "Copying global config to: $OPENDOC_CONFIG_FILE"
/bin/cp "$GLOBAL_CONFIG_FILE" "$OPENDOC_CONFIG_FILE"

echo "OpenCode configuration updated successfully."
