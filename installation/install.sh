#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
MAIN_SCRIPT="leetcode-daily.sh"  # Change this if your main script has a different name
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/leetcode-daily"
ALIAS_NAME="leetcode-daily"

echo -e "${CYAN}🚀 LeetCode Daily Problem Fetcher - Installation${NC}"
echo "================================================"

# Get the directory where this install script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}📍 Script directory: $SCRIPT_DIR${NC}"
echo -e "${BLUE}📍 Parent directory: $PARENT_DIR${NC}"

# Look for the main script in the parent directory
MAIN_SCRIPT_PATH="$PARENT_DIR/$MAIN_SCRIPT"

if [ ! -f "$MAIN_SCRIPT_PATH" ]; then
    echo -e "${RED}❌ Error: $MAIN_SCRIPT not found at $MAIN_SCRIPT_PATH${NC}"
    echo -e "${YELLOW}💡 Looking for other script files...${NC}"
    
    # Try to find any .sh files in parent directory
    for script in "$PARENT_DIR"/*.sh; do
        if [ -f "$script" ] && [ "$(basename "$script")" != "$(basename "$0")" ]; then
            echo -e "${YELLOW}Found: $(basename "$script")${NC}"
            read -p "Is this your main script? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                MAIN_SCRIPT_PATH="$script"
                MAIN_SCRIPT="$(basename "$script")"
                break
            fi
        fi
    done
    
    if [ ! -f "$MAIN_SCRIPT_PATH" ]; then
        echo -e "${RED}❌ Could not locate the main script${NC}"
        echo -e "${YELLOW}Please ensure your main script is in: $PARENT_DIR${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Found main script: $MAIN_SCRIPT_PATH${NC}"

# Create directories
echo -e "${BLUE}📁 Creating directories...${NC}"
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"

# Copy script to install directory
echo -e "${BLUE}📋 Installing script...${NC}"
cp "$MAIN_SCRIPT_PATH" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/$MAIN_SCRIPT"

# Create default settings.conf if it doesn't exist
SETTINGS_FILE="$CONFIG_DIR/settings.conf"
if [ ! -f "$SETTINGS_FILE" ]; then
    echo -e "${BLUE}📝 Creating default settings.conf...${NC}"
    cat > "$SETTINGS_FILE" << EOF
# LeetCode Daily Challenge Settings
# Set to true/false to enable/disable file generation for each language

GENERATE_PYTHON=true
GENERATE_JAVASCRIPT=true
GENERATE_CSHARP=true

# Future settings can be added here
# GENERATE_JAVA=false
# GENERATE_CPP=false
EOF
    echo -e "${GREEN}✅ Created default settings at $SETTINGS_FILE${NC}"
else
    echo -e "${YELLOW}⚠️  Settings file already exists at $SETTINGS_FILE${NC}"
fi

# Create a wrapper script that handles the config file location
WRAPPER_SCRIPT="$INSTALL_DIR/leetcode-daily-wrapper.sh"
cat > "$WRAPPER_SCRIPT" << EOF
#!/bin/bash
# Wrapper script to handle config file location

CONFIG_FILE="\$HOME/.config/leetcode-daily/settings.conf"
TEMP_CONFIG="/tmp/leetcode-daily-settings.conf"

# Copy config to current directory temporarily if it exists
if [ -f "\$CONFIG_FILE" ]; then
    cp "\$CONFIG_FILE" "./settings.conf"
fi

# Run the main script
"$INSTALL_DIR/$MAIN_SCRIPT" "\$@"

# Clean up temporary config file
if [ -f "./settings.conf" ] && [ -f "\$CONFIG_FILE" ]; then
    rm "./settings.conf"
fi
EOF

chmod +x "$WRAPPER_SCRIPT"

# Detect shell and add to PATH
echo -e "${BLUE}🔧 Setting up shell integration...${NC}"

# Function to add to shell profile
add_to_profile() {
    local profile_file="$1"
    local profile_name="$2"
    
    if [ -f "$profile_file" ]; then
        # Check if alias already exists
        if ! grep -q "$ALIAS_NAME" "$profile_file"; then
            echo "# LeetCode Daily - Added by install script" >> "$profile_file"
            echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$profile_file"
            echo "alias $ALIAS_NAME=\"$WRAPPER_SCRIPT\"" >> "$profile_file"
            echo "" >> "$profile_file"
            echo -e "${GREEN}✅ Added to $profile_name${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️  $profile_name already has $ALIAS_NAME configured${NC}"
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
    if ! grep -q "$ALIAS_NAME" "$fish_config"; then
        echo "# LeetCode Daily - Added by install script" >> "$fish_config"
        echo "set -gx PATH \$PATH $INSTALL_DIR" >> "$fish_config"
        echo "alias $ALIAS_NAME=\"$WRAPPER_SCRIPT\"" >> "$fish_config"
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
    echo "  Windows (WSL): sudo apt install jq"
fi

echo ""
echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
echo ""
echo -e "${YELLOW}📋 What was installed:${NC}"
echo "  • Main script: $INSTALL_DIR/$MAIN_SCRIPT"
echo "  • Wrapper script: $WRAPPER_SCRIPT"
echo "  • Settings file: $SETTINGS_FILE"
echo "  • Shell alias: $ALIAS_NAME"
echo ""
echo -e "${YELLOW}Next steps:${NC}"

if [ "$updated" = true ]; then
    echo "1. Restart your terminal or run: source ~/.bashrc (or your shell profile)"
    echo "2. Use the command: $ALIAS_NAME"
    echo "3. Edit settings: $SETTINGS_FILE"
else
    echo "1. Add this to your shell profile manually:"
    echo -e "   ${CYAN}export PATH=\"\$PATH:$INSTALL_DIR\"${NC}"
    echo -e "   ${CYAN}alias $ALIAS_NAME=\"$WRAPPER_SCRIPT\"${NC}"
    echo "2. Restart your terminal or source your profile"
    echo "3. Use the command: $ALIAS_NAME"
    echo "4. Edit settings: $SETTINGS_FILE"
fi

echo ""
echo -e "${BLUE}📚 Usage:${NC}"
echo "  $ALIAS_NAME                # Generate files for today's problem"
echo "  $ALIAS_NAME --terminal     # Display problem in terminal only"
echo "  $ALIAS_NAME --help         # Show help message"
echo ""
echo -e "${BLUE}⚙️  Configuration:${NC}"
echo "  Edit $SETTINGS_FILE to customize which languages to generate"
echo ""
echo -e "${CYAN}🚀 Ready to use! Run: $ALIAS_NAME --help${NC}"