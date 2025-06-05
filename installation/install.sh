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

echo -e "${CYAN}🚀 LeetCode Daily Problem Fetcher - Installation${NC}"
echo "================================================"

# Check if script exists
if [ ! -f "$SCRIPT_NAME" ]; then
    echo -e "${RED}❌ Error: $SCRIPT_NAME not found in current directory${NC}"
    echo -e "${YELLOW}Make sure you're running this from the bashscript directory${NC}"
    exit 1
fi

# Create directories
echo -e "${BLUE}📁 Creating directories...${NC}"
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"

# Copy script to install directory
echo -e "${BLUE}📋 Installing script...${NC}"
cp "$SCRIPT_NAME" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Copy config if it exists
if [ -f "config/settings.conf" ]; then
    cp "config/settings.conf" "$CONFIG_DIR/"
fi

# Detect shell and add to PATH
echo -e "${BLUE}🔧 Setting up shell integration...${NC}"

# Function to add to shell profile
add_to_profile() {
    local profile_file="$1"
    local profile_name="$2"
    
    if [ -f "$profile_file" ]; then
        # Check if PATH already includes our directory
        if ! grep -q "$INSTALL_DIR" "$profile_file"; then
            echo "# LeetCode Daily - Added by install script" >> "$profile_file"
            echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$profile_file"
            echo "alias $ALIAS_NAME=\"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$profile_file"
            echo "" >> "$profile_file"
            echo -e "${GREEN}✅ Added to $profile_name${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️  $profile_name already configured${NC}"
            return 1
        fi
    fi
    return 1
}

# Try to add to various shell profiles
updated=false

# Bash
if add_to_profile "$HOME/.bashrc" "~/.bashrc"; then
    updated=true
elif add_to_profile "$HOME/.bash_profile" "~/.bash_profile"; then
    updated=true
fi

# Zsh
if add_to_profile "$HOME/.zshrc" "~/.zshrc"; then
    updated=true
fi

# Fish
if [ -f "$HOME/.config/fish/config.fish" ]; then
    fish_config="$HOME/.config/fish/config.fish"
    if ! grep -q "$INSTALL_DIR" "$fish_config"; then
        echo "# LeetCode Daily - Added by install script" >> "$fish_config"
        echo "set -gx PATH \$PATH $INSTALL_DIR" >> "$fish_config"
        echo "alias $ALIAS_NAME=\"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$fish_config"
        echo "" >> "$fish_config"
        echo -e "${GREEN}✅ Added to Fish config${NC}"
        updated=true
    fi
fi

# Check dependencies
echo -e "${BLUE}🔍 Checking dependencies...${NC}"

check_dependency() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✅ $1 is installed${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  $1 is not installed${NC}"
        return 1
    fi
}

check_dependency "curl"
if ! check_dependency "jq"; then
    echo -e "${YELLOW}📝 To install jq:${NC}"
    echo "  Ubuntu/Debian: sudo apt install jq"
    echo "  macOS: brew install jq"
    echo "  CentOS/RHEL: sudo yum install jq"
fi

echo ""
echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"

if [ "$updated" = true ]; then
    echo "1. Restart your terminal or run: source ~/.bashrc (or your shell profile)"
    echo "2. Use the command: $ALIAS_NAME"
else
    echo "1. Add this to your shell profile manually:"
    echo -e "   ${CYAN}export PATH=\"\$PATH:$INSTALL_DIR\"${NC}"
    echo -e "   ${CYAN}alias $ALIAS_NAME=\"$INSTALL_DIR/$SCRIPT_NAME\"${NC}"
    echo "2. Restart your terminal or source your profile"
    echo "3. Use the command: $ALIAS_NAME"
fi

echo ""
echo -e "${BLUE}📍 Installed files:${NC}"
echo "  Script: $INSTALL_DIR/$SCRIPT_NAME"
echo "  Config: $CONFIG_DIR/"
echo ""
echo -e "${CYAN}For help, run: $ALIAS_NAME --help${NC}"