#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SCRIPT_NAME="leetcode-daily.sh"
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/leetcode-daily"
ALIAS_NAME="leetcode-daily"

echo -e "${CYAN}🗑️  LeetCode Daily Problem Fetcher - Uninstallation${NC}"
echo "===================================================="

# Function to remove from shell profile
remove_from_profile() {
    local profile_file="$1"
    local profile_name="$2"
    
    if [ -f "$profile_file" ]; then
        # Create a backup
        cp "$profile_file" "$profile_file.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Remove lines containing our additions
        sed -i '/# LeetCode Daily - Added by install script/,+2d' "$profile_file" 2>/dev/null
        sed -i "/export PATH=.*$INSTALL_DIR/d" "$profile_file" 2>/dev/null
        sed -i "/alias $ALIAS_NAME=/d" "$profile_file" 2>/dev/null
        
        echo -e "${GREEN}✅ Cleaned $profile_name${NC}"
        return 0
    fi
    return 1
}

# Remove script files
echo -e "${BLUE}🗂️  Removing installed files...${NC}"

if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    rm "$INSTALL_DIR/$SCRIPT_NAME"
    echo -e "${GREEN}✅ Removed script from $INSTALL_DIR${NC}"
else
    echo -e "${YELLOW}⚠️  Script not found in $INSTALL_DIR${NC}"
fi

# Remove config directory
if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    echo -e "${GREEN}✅ Removed config directory${NC}"
else
    echo -e "${YELLOW}⚠️  Config directory not found${NC}"
fi

# Clean shell profiles
echo -e "${BLUE}🔧 Cleaning shell profiles...${NC}"

# Bash
remove_from_profile "$HOME/.bashrc" "~/.bashrc"
remove_from_profile "$HOME/.bash_profile" "~/.bash_profile"

# Zsh
remove_from_profile "$HOME/.zshrc" "~/.zshrc"

# Fish
if [ -f "$HOME/.config/fish/config.fish" ]; then
    fish_config="$HOME/.config/fish/config.fish"
    cp "$fish_config" "$fish_config.backup.$(date +%Y%m%d_%H%M%S)"
    sed -i '/# LeetCode Daily - Added by install script/,+2d' "$fish_config" 2>/dev/null
    sed -i "/set -gx PATH.*$INSTALL_DIR/d" "$fish_config" 2>/dev/null
    sed -i "/alias $ALIAS_NAME=/d" "$fish_config" 2>/dev/null
    echo -e "${GREEN}✅ Cleaned Fish config${NC}"
fi

# Check if installation directory is empty and can be removed
if [ -d "$INSTALL_DIR" ] && [ -z "$(ls -A $INSTALL_DIR)" ]; then
    rmdir "$INSTALL_DIR"
    echo -e "${GREEN}✅ Removed empty install directory${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Uninstallation completed successfully!${NC}"
echo ""
echo -e "${YELLOW}Note:${NC}"
echo "• Shell profile backups were created with timestamp"
echo "• Restart your terminal or source your profile to apply changes"
echo "• The command '$ALIAS_NAME' will no longer be available"
echo ""
echo -e "${BLUE}To check if removal was successful:${NC}"
echo "• Run: which $ALIAS_NAME (should return nothing)"
echo "• Or try: $ALIAS_NAME (should show 'command not found')"
echo ""
echo -e "${CYAN}Thank you for using LeetCode Daily Problem Fetcher! 👋${NC}"