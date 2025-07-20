#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration - matches the updated install script
MAIN_SCRIPT="leetcode-daily.sh"  # Change this if your main script has a different name
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/leetcode-daily"
ALIAS_NAME="leetcode-daily"
WRAPPER_SCRIPT="$INSTALL_DIR/leetcode-daily-wrapper.sh"

echo -e "${CYAN}  LeetCode Daily Problem Fetcher - Uninstallation${NC}"
echo "===================================================="

# Confirmation prompt
echo -e "${YELLOW}  This will remove:${NC}"
echo "  • Main script: $INSTALL_DIR/$MAIN_SCRIPT"
echo "  • Wrapper script: $WRAPPER_SCRIPT"
echo "  • Config directory: $CONFIG_DIR"
echo "  • Shell aliases and PATH modifications"
echo ""
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Uninstallation cancelled.${NC}"
    exit 0
fi

# Function to remove from shell profile
remove_from_profile() {
    local profile_file="$1"
    local profile_name="$2"
    
    if [ -f "$profile_file" ]; then
        # Create a backup
        backup_file="$profile_file.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$profile_file" "$backup_file"
        echo -e "${BLUE} Created backup: $backup_file${NC}"
        
        # Remove lines containing our additions
        # Remove the comment line and the following lines
        sed -i '/# LeetCode Daily - Added by install script/,+3d' "$profile_file" 2>/dev/null
        
        # Also remove any standalone lines that might have been added separately
        sed -i "/export PATH=.*$(echo "$INSTALL_DIR" | sed 's/[[\.*^$()+?{|]/\\&/g')/d" "$profile_file" 2>/dev/null
        sed -i "/alias $ALIAS_NAME=/d" "$profile_file" 2>/dev/null
        
        echo -e "${GREEN} Cleaned $profile_name${NC}"
        return 0
    fi
    return 1
}

# Remove script files
echo -e "${BLUE}  Removing installed files...${NC}"

# Remove main script
if [ -f "$INSTALL_DIR/$MAIN_SCRIPT" ]; then
    rm "$INSTALL_DIR/$MAIN_SCRIPT"
    echo -e "${GREEN} Removed main script: $INSTALL_DIR/$MAIN_SCRIPT${NC}"
else
    echo -e "${YELLOW}  Main script not found: $INSTALL_DIR/$MAIN_SCRIPT${NC}"
fi

# Remove wrapper script
if [ -f "$WRAPPER_SCRIPT" ]; then
    rm "$WRAPPER_SCRIPT"
    echo -e "${GREEN} Removed wrapper script: $WRAPPER_SCRIPT${NC}"
else
    echo -e "${YELLOW}  Wrapper script not found: $WRAPPER_SCRIPT${NC}"
fi

# Look for any other related files
echo -e "${BLUE} Checking for other related files...${NC}"
for file in "$INSTALL_DIR"/leetcode-daily*; do
    if [ -f "$file" ]; then
        echo -e "${YELLOW}Found: $file${NC}"
        read -p "Remove this file? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$file"
            echo -e "${GREEN} Removed: $file${NC}"
        fi
    fi
done

# Remove config directory
if [ -d "$CONFIG_DIR" ]; then
    echo -e "${YELLOW} Config directory contains:${NC}"
    ls -la "$CONFIG_DIR"
    echo ""
    read -p "Remove config directory and all settings? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$CONFIG_DIR"
        echo -e "${GREEN} Removed config directory${NC}"
    else
        echo -e "${BLUE}  Keeping config directory for future use${NC}"
    fi
else
    echo -e "${YELLOW} Config directory not found: $CONFIG_DIR${NC}"
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
    backup_file="$fish_config.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$fish_config" "$backup_file"
    echo -e "${BLUE} Created backup: $backup_file${NC}"
    
    # Remove Fish-specific lines
    sed -i '/# LeetCode Daily - Added by install script/,+3d' "$fish_config" 2>/dev/null
    sed -i "/set -gx PATH.*$(echo "$INSTALL_DIR" | sed 's/[[\.*^$()+?{|]/\\&/g')/d" "$fish_config" 2>/dev/null
    sed -i "/alias $ALIAS_NAME=/d" "$fish_config" 2>/dev/null
    
    echo -e "${GREEN} Cleaned Fish config${NC}"
fi

# Check if installation directory is empty and can be removed
if [ -d "$INSTALL_DIR" ]; then
    remaining_files=$(ls -A "$INSTALL_DIR" 2>/dev/null | wc -l)
    if [ "$remaining_files" -eq 0 ]; then
        rmdir "$INSTALL_DIR"
        echo -e "${GREEN} Removed empty install directory${NC}"
    else
        echo -e "${BLUE} Install directory contains other files, keeping it${NC}"
    fi
fi

# Clean up any temporary files that might have been created
echo -e "${BLUE} Cleaning up temporary files...${NC}"
if [ -f "./settings.conf" ]; then
    # Check if it's a temporary file (recently created and matches our config)
    if [ -f "$CONFIG_DIR/settings.conf" ] && cmp -s "./settings.conf" "$CONFIG_DIR/settings.conf" 2>/dev/null; then
        rm "./settings.conf"
        echo -e "${GREEN} Removed temporary settings file${NC}"
    fi
fi

echo ""
echo -e "${GREEN}🎉 Uninstallation completed successfully!${NC}"
echo ""
echo -e "${YELLOW} Summary:${NC}"
echo "• Removed all installed scripts and files"
echo "• Cleaned shell profile configurations"
echo "• Created backups of modified files"
if [ -d "$CONFIG_DIR" ]; then
    echo "• Config directory preserved (remove manually if desired)"
fi
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart your terminal or source your shell profile"
echo "2. The command '$ALIAS_NAME' will no longer be available"
echo ""
echo -e "${BLUE} To verify removal:${NC}"
echo "  which $ALIAS_NAME          # Should return nothing"
echo "  $ALIAS_NAME --help         # Should show 'command not found'"
echo ""
echo -e "${BLUE} Backup files created:${NC}"
echo "  Check for .backup.* files in your home directory"
echo ""
echo -e "${CYAN}Thank you for using LeetCode Daily Problem Fetcher! 👋${NC}"
echo -e "${YELLOW}If you reinstall later, your settings will be preserved.${NC}"