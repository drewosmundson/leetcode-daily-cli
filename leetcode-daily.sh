#!/bin/bash

# Colors for better terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display the daily problem
fetch_daily_problem() {
    echo -e "${CYAN}🚀 Fetching today's LeetCode daily challenge...${NC}\n"
    
    # Fetch the daily problem
    response=$(curl -s https://leetcode-api-pied.vercel.app/daily)
    
    # Check if curl was successful
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error: Failed to fetch data from LeetCode API${NC}"
        exit 1
    fi
    
    # Extract information using jq (JSON processor)
    if command -v jq &> /dev/null; then
        # Using jq for better JSON parsing
        date=$(echo "$response" | jq -r '.date')
        title=$(echo "$response" | jq -r '.question.title')
        difficulty=$(echo "$response" | jq -r '.question.difficulty')
        question_id=$(echo "$response" | jq -r '.question.questionFrontendId')
        link=$(echo "$response" | jq -r '.link')
        content=$(echo "$response" | jq -r '.question.content')
        
        # Display the information
        echo -e "${PURPLE}📅 Date:${NC} $date"
        echo -e "${BLUE}🔢 Problem #${question_id}:${NC} $title"
        
        # Color code difficulty
        case $difficulty in
            "Easy")
                echo -e "${GREEN}🟢 Difficulty:${NC} $difficulty"
                ;;
            "Medium")
                echo -e "${YELLOW}🟡 Difficulty:${NC} $difficulty"
                ;;
            "Hard")
                echo -e "${RED}🔴 Difficulty:${NC} $difficulty"
                ;;
        esac
        
        echo -e "${CYAN}🔗 LeetCode Link:${NC} https://leetcode.com$link"
        echo ""
        echo -e "${PURPLE}📝 Problem Description:${NC}"
        echo "────────────────────────────────────────"
        
        # Clean up HTML content (basic cleanup and remove excessive line breaks)
        clean_content=$(echo "$content" | sed 's/<[^>]*>//g' | sed 's/&quot;/"/g' | sed 's/&#39;/'"'"'/g' | sed 's/&lt;/</g' | sed 's/&gt;/>/g' | sed 's/&nbsp;/ /g' | sed '/^$/d' | sed 's/^[ \t]*//')
        echo -e "$clean_content"
        
    else
        # Fallback without jq - basic parsing
        echo -e "${YELLOW}⚠️  jq not found. Install jq for better formatting: sudo apt install jq${NC}\n"
        echo -e "${BLUE}Raw response:${NC}"
        echo "$response" | python3 -m json.tool 2>/dev/null || echo "$response"
    fi
}

# Function to display help
show_help() {
    echo -e "${CYAN}📚 LeetCode Daily Problem Fetcher${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  $0                    # Fetch today's daily problem"
    echo "  $0 --help           # Show this help message"
    echo "  $0 --setup          # Setup script with alias"
    echo ""
    echo -e "${YELLOW}Requirements:${NC}"
    echo "  - curl (for API requests)"
    echo "  - jq (optional, for better JSON formatting)"
    echo ""
    echo -e "${YELLOW}Install jq:${NC}"
    echo "  Ubuntu/Debian: sudo apt install jq"
    echo "  macOS: brew install jq"
    echo "  CentOS/RHEL: sudo yum install jq"
}

# Function to setup alias
setup_script() {
    script_path=$(realpath "$0")
    alias_command="alias leetcode-daily='$script_path'"
    
    echo -e "${CYAN}🔧 Setting up LeetCode Daily alias...${NC}"
    echo ""
    echo -e "${YELLOW}Add this line to your shell profile:${NC}"
    echo -e "${GREEN}$alias_command${NC}"
    echo ""
    echo -e "${YELLOW}Shell profiles:${NC}"
    echo "  - Bash: ~/.bashrc or ~/.bash_profile"
    echo "  - Zsh: ~/.zshrc"
    echo "  - Fish: ~/.config/fish/config.fish"
    echo ""
    echo -e "${YELLOW}After adding the alias, run:${NC} source ~/.bashrc (or your shell profile)"
    echo -e "${YELLOW}Then you can use:${NC} leetcode-daily"
}

# Main script logic
case "${1:-}" in
    --help|-h)
        show_help
        ;;
    --setup)
        setup_script
        ;;
    "")
        fetch_daily_problem
        ;;
    *)
        echo -e "${RED}❌ Unknown option: $1${NC}"
        echo -e "${YELLOW}Use --help for usage information${NC}"
        exit 1
        ;;
esac