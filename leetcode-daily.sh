
#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Load settings from settings.conf
load_settings() {
    local config_file="./settings.conf"
    if [ -f "$config_file" ]; then
        source "$config_file"
    else
        echo -e "${YELLOW}⚠️  settings.conf not found. Defaulting to all languages.${NC}"
        GENERATE_PYTHON=true
        GENERATE_JAVASCRIPT=true
        GENERATE_CSHARP=true
    fi
}

# Function to display the daily problem in terminal
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

# Function to clean HTML content and format for comments
clean_html() {
    echo "$1" | sed 's/<[^>]*>//g' | sed 's/&quot;/"/g' | sed 's/&#39;/'"'"'/g' | sed 's/&lt;/</g' | sed 's/&gt;/>/g' | sed 's/&nbsp;/ /g' | sed '/^$/d' | sed 's/^[ \t]*//'
}

# Function to create comment block
create_comment_block() {
    local content="$1"
    local comment_prefix="$2"
    local max_width=80
    
    echo "$content" | while IFS= read -r line; do
        if [ -z "$line" ]; then
            echo "$comment_prefix"
        else
            # Wrap long lines
            echo "$line" | fold -s -w $((max_width - ${#comment_prefix})) | sed "s/^/$comment_prefix/"
        fi
    done
}

# Function to create Python file
create_python_file() {
    local date="$1"
    local title="$2"
    local problem_id="$3"
    local difficulty="$4"
    local content="$5"
    local link="$6"
    
    local filename="${problem_id}_$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/_$//').py"
    
    cat > "$filename" << EOF
"""
LeetCode Daily Challenge - ${date}
Problem #${problem_id}: ${title}
Difficulty: ${difficulty}
Link: https://leetcode.com${link}

$(create_comment_block "$(clean_html "$content")" "")
"""

class Solution:
    def ${method_name}(self, ${method_params}) -> ${method_return}:
        """
        TODO: Implement solution
        
        Args:
            ${method_params}: TODO - describe parameters
            
        Returns:
            ${method_return}: TODO - describe return value
            
        Time Complexity: O(?)
        Space Complexity: O(?)
        """
        pass


def test_solution():
    """Test the solution with provided examples"""
    solution = Solution()
    
    # TODO: Add test cases from problem description
    # Example:
    # result = solution.${method_name}(test_input)
    # expected = expected_output
    # assert result == expected, f"Expected {expected}, got {result}"
    
    print("✅ All tests passed!")


if __name__ == "__main__":
    test_solution()

# TODO: Add execution output below
# ========== EXECUTION OUTPUT ==========
# python ${filename}
# ======================================
EOF
    
    echo "$filename"
}

# Function to create JavaScript file
create_javascript_file() {
    local date="$1"
    local title="$2"
    local problem_id="$3"
    local difficulty="$4"
    local content="$5"
    local link="$6"
    
    local filename="${problem_id}_$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/_$//').js"
    
    cat > "$filename" << EOF
/**
 * LeetCode Daily Challenge - ${date}
 * Problem #${problem_id}: ${title}
 * Difficulty: ${difficulty}
 * Link: https://leetcode.com${link}
 * 
$(create_comment_block "$(clean_html "$content")" " * ")
 */

/**
 * @param {TODO} param1
 * @param {TODO} param2
 * @return {TODO}
 */
var ${method_name} = function(${method_params}) {
    // TODO: Implement solution
    
    // Time Complexity: O(?)
    // Space Complexity: O(?)
    
    return null;
};

// Alternative ES6 Class approach
class Solution {
    /**
     * @param {TODO} param1
     * @param {TODO} param2
     * @return {TODO}
     */
    ${method_name}(${method_params}) {
        // TODO: Implement solution
        return null;
    }
}

// Test function
function testSolution() {
    // TODO: Add test cases from problem description
    // Example:
    // const result = ${method_name}(testInput);
    // const expected = expectedOutput;
    // console.assert(result === expected, \`Expected \${expected}, got \${result}\`);
    
    console.log("✅ All tests passed!");
}

// Run tests
testSolution();

// TODO: Add execution output below
// ========== EXECUTION OUTPUT ==========
// node ${filename}
// ======================================
EOF
    
    echo "$filename"
}
create_csharp_project() {
    local date="$1"
    local title="$2"
    local problem_id="$3"
    local difficulty="$4"
    local content="$5"
    local link="$6"
    
    local project_name="${problem_id}_$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/_$//')"
    
    # Check if dotnet is available
    if ! command -v dotnet >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  dotnet CLI not found. Creating standalone C# file instead.${NC}"
        create_csharp_file "$date" "$title" "$problem_id" "$difficulty" "$content" "$link"
        return
    fi
    
    # Create dotnet console project
    dotnet new console -n "$project_name" --force > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        # Replace Program.cs content
        cat > "$project_name/Program.cs" << EOF
/*
 * LeetCode Daily Challenge - ${date}
 * Problem #${problem_id}: ${title}
 * Difficulty: ${difficulty}
 * Link: https://leetcode.com${link}
 * 
$(create_comment_block "$(clean_html "$content")" " * ")
 */

using System;
using System.Collections.Generic;
using System.Linq;

public class Solution 
{
    public ${method_return} ${method_name}() 
    {
        // TODO: Implement solution
        return default(${method_return});
    }
}

class Program 
{
    static void Main() 
    {
        Solution solution = new Solution();
        
        // TODO: Add test cases
    }
}
// TODO: Add execution output below
// ========== EXECUTION OUTPUT ==========
// cd $project_name
// dotnet run
// ======================================
EOF

        echo "$project_name"
    else
        echo -e "${RED}❌ Failed to create dotnet project. Creating standalone file.${NC}"
        create_csharp_file "$date" "$title" "$problem_id" "$difficulty" "$content" "$link"
    fi
}

# Function to create C# file
create_csharp_file() {

    local date="$1"
    local title="$2"
    local problem_id="$3"
    local difficulty="$4"
    local content="$5"
    local link="$6"
    
    local filename="${problem_id}_$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/_$//').cs"
    

    cat > "$filename" << EOF
/*
 * LeetCode Daily Challenge - ${date}
 * Problem #${problem_id}: ${title}
 * Difficulty: ${difficulty}
 * Link: https://leetcode.com${link}
 * 
$(create_comment_block "$(clean_html "$content")" " * ")
 */

using System;
using System.Collections.Generic;
using System.Linq;

public class Solution 
{
    /// <summary>
    /// TODO: Implement solution
    /// </summary>
    /// <param name="param1">TODO: Describe parameter</param>
    /// <param name="param2">TODO: Describe parameter</param>
    /// <returns>TODO: Describe return value</returns>
    /// <remarks>
    /// Time Complexity: O(?)
    /// Space Complexity: O(?)
    /// </remarks>
    public ${method_return} ${method_name}(${method_params}) 
    {
        // TODO: Implement solution
        
        return default(${method_return});
    }
}

class Program 
{
    static void Main() 
    {
        Solution solution = new Solution(${method_params});
        
        // TODO: Add test cases from problem description
        // Example:
        // var result = solution.${method_name}(testInput);
        // var expected = expectedOutput;
        // System.Diagnostics.Debug.Assert(result.Equals(expected), \$"Expected {expected}, got {result}");
        
        Console.WriteLine("✅ All tests passed!");
    }
}

// TODO: Add execution output below
// ========== EXECUTION OUTPUT ==========
// csc ${filename} && mono ${filename%.*}.exe
// ======================================
EOF
    
    echo "$filename"
}

# Function to extract method info from problem (basic heuristic)
extract_method_info() {
    local title="$1"
    
    # Convert title to camelCase method name
    method_name=$(echo "$title" | sed 's/[^a-zA-Z0-9 ]//g' | awk '{
        result = tolower(substr($1,1,1)) substr($1,2)
        for(i=2; i<=NF; i++) {
            result = result toupper(substr($i,1,1)) substr($i,2)
        }
        print result
    }')
    
    # Default parameters and return type (user will need to customize)
    method_params="param1, param2"
    method_return="string"
    
    export method_name method_params method_return
}

# Function to create directory structure
create_directory_structure() {
    local date="$1"
    local dir_name="daily_$(echo $date | tr '-' '_')"
    
    mkdir -p "$dir_name"
    
    echo "$dir_name"
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

# Main function for file generation
generate_files() {
    echo -e "${CYAN}🚀 Fetching today's LeetCode daily challenge...${NC}\n"
    
    # Fetch the daily problem
    response=$(curl -s https://leetcode-api-pied.vercel.app/daily)
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error: Failed to fetch data from LeetCode API${NC}"
        exit 1
    fi
    
    # Check if jq is available for JSON parsing
    if ! command -v jq >/dev/null 2>&1; then
        echo -e "${RED}❌ Error: jq is required for JSON parsing${NC}"
        echo -e "${YELLOW}Install with: sudo apt install jq (Ubuntu) or brew install jq (macOS)${NC}"
        exit 1
    fi
    
    # Extract information
    date=$(echo "$response" | jq -r '.date')
    title=$(echo "$response" | jq -r '.question.title')
    difficulty=$(echo "$response" | jq -r '.question.difficulty')
    problem_id=$(echo "$response" | jq -r '.question.questionFrontendId')
    link=$(echo "$response" | jq -r '.link')
    content=$(echo "$response" | jq -r '.question.content')
    
    echo -e "${PURPLE}📅 Date:${NC} $date"
    echo -e "${BLUE}🔢 Problem #${problem_id}:${NC} $title"
    echo -e "${YELLOW}🎯 Difficulty:${NC} $difficulty"
    echo -e "${CYAN}🔗 LeetCode Link:${NC} https://leetcode.com$link"
    echo ""
    
    # Extract method information
    extract_method_info "$title"

    load_settings

    # Create directory structure
    if [ ! -d "leetcode_problems" ]; then
    mkdir "leetcode_problems"
    fi

    cd "leetcode_problems"
    dir_name=$(create_directory_structure "$date")
    cd "$dir_name"
    

    echo -e "${PURPLE}📋 Summary:${NC}"
    echo "────────────────────────────────────────"
    echo -e "${YELLOW}Directory:${NC} $dir_name"
    echo -e "${YELLOW}Files created:${NC}"
    # Conditionally generate files
    if [ "$GENERATE_PYTHON" = true ]; then
        python_file=$(create_python_file "$date" "$title" "$problem_id" "$difficulty" "$content" "$link")
        echo "  🐍 $python_file"
    fi

    if [ "$GENERATE_JAVASCRIPT" = true ]; then
        js_file=$(create_javascript_file "$date" "$title" "$problem_id" "$difficulty" "$content" "$link")
        echo "  🟨 $js_file"
    fi

    if [ "$GENERATE_CSHARP" = true ]; then
        cs_project=$(create_csharp_project "$date" "$title" "$problem_id" "$difficulty" "$content" "$link")
        echo "  🔷 $cs_project"
    fi
    echo ""
    echo -e "${CYAN}🚀 Next steps:${NC}"
    echo "1. cd $dir_name"
    echo "2. Edit the files and implement your solutions"
    echo "3. Customize method signatures and parameters"
    echo "4. Add test cases from the problem examples"
    echo "5. Run your solutions and capture output"
    echo ""
    echo -e "${GREEN}Happy coding! 🎉${NC}"
}

# Show help
show_help() {
    echo -e "${CYAN}📚 LeetCode Daily Challenge Tool${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  $0                    # Generate files for today's problem"
    echo "  $0 --terminal        # Display problem in terminal only"
    echo "  $0 --setup           # Setup script with alias"
    echo "  $0 --help            # Show this help message"
    echo ""
    echo -e "${YELLOW}Requirements:${NC}"
    echo "  - curl (for API requests)"
    echo "  - jq (for JSON parsing)"
    echo ""
    echo -e "${YELLOW}Modes:${NC}"
    echo "  • ${GREEN}File Generation Mode (default):${NC}"
    echo "    - Fetches today's LeetCode daily challenge"
    echo "    - Creates a dedicated folder for the problem"
    echo "    - Generates 3 files: Python (.py), JavaScript (.js), C# (.cs)"
    echo "    - Includes problem description as comments"
    echo "    - Provides solution templates for each language"
    echo "    - Sets up test structure and execution placeholders"
    echo ""
    echo "  • ${GREEN}Terminal Display Mode (--terminal):${NC}"
    echo "    - Displays the problem directly in terminal"
    echo "    - Shows formatted problem description"
    echo "    - Color-coded difficulty and information"
    echo "    - No files are created"
    echo ""
    echo -e "${YELLOW}Install jq:${NC}"
    echo "  Ubuntu/Debian: sudo apt install jq"
    echo "  macOS: brew install jq"
    echo "  CentOS/RHEL: sudo yum install jq"
}

# Main script logic
case "${1:-}" in
    --help|-h)
        show_help
        ;;
    --terminal|-t)
        fetch_daily_problem
        ;;
    --setup)
        setup_script
        ;;
    "")
        generate_files
        ;;
    *)
        echo -e "${RED}❌ Unknown option: $1${NC}"
        echo -e "${YELLOW}Use --help for usage information${NC}"
        exit 1
        ;;
esac