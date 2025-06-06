#!/bin/bash

# Colors for test output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SCRIPT_PATH="../leetcode-daily.sh"
PASSED=0
FAILED=0

echo -e "${CYAN}🧪 LeetCode Daily Problem Fetcher - Tests${NC}"
echo "============================================="

# Test function
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_exit_code="${3:-0}"
    
    echo -n -e "${BLUE}Testing: $test_name...${NC} "
    
    # Run the command and capture output and exit code
    output=$(eval "$command" 2>&1)
    exit_code=$?
    
    if [ $exit_code -eq $expected_exit_code ]; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo -e "${YELLOW}Expected exit code: $expected_exit_code${NC}"
        echo -e "${YELLOW}Actual exit code: $exit_code${NC}"
        echo -e "${YELLOW}Output: $output${NC}"
        ((FAILED++))
        return 1
    fi
}

# Check if main script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo -e "${RED}❌ Main script not found at $SCRIPT_PATH${NC}"
    exit 1
fi

# Make sure script is executable
chmod +x "$SCRIPT_PATH"

echo -e "${BLUE}📋 Running basic tests...${NC}\n"

# Test 1: Help option
run_test "Help option (--help)" "$SCRIPT_PATH --help"

# Test 2: Help option short form
run_test "Help option (-h)" "$SCRIPT_PATH -h"

# Test 3: Setup option
run_test "Setup option (--setup)" "$SCRIPT_PATH --setup"

# Test 4: Invalid option (should fail)
run_test "Invalid option (should fail)" "$SCRIPT_PATH --invalid" 1

# Test 5: Check for required dependencies
echo -e "\n${BLUE}🔍 Checking dependencies...${NC}"

check_dependency() {
    local dep="$1"
    if command -v "$dep" &> /dev/null; then
        echo -e "${GREEN}✅ $dep is available${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  $dep is not available${NC}"
        return 1
    fi
}

check_dependency "curl"
check_dependency "jq"

# Test 6: API connectivity (if curl is available)
if command -v curl &> /dev/null; then
    echo -e "\n${BLUE}🌐 Testing API connectivity...${NC}"
    run_test "API connectivity" "curl -s --connect-timeout 5 https://leetcode-api-pied.vercel.app/daily > /dev/null"
else
    echo -e "${YELLOW}⚠️  Skipping API test (curl not available)${NC}"
fi

# Test 7: Script syntax check
echo -e "\n${BLUE}🔍 Checking script syntax...${NC}"
run_test "Script syntax check" "bash -n $SCRIPT_PATH"

# Test 8: Try to run the main functionality (with timeout)
echo -e "\n${BLUE}🚀 Testing main functionality...${NC}"
run_test "Main script execution (with timeout)" "timeout 30s $SCRIPT_PATH"

# Summary
echo -e "\n${CYAN}📊 Test Summary${NC}"
echo "=================="
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
echo -e "${RED}❌ Failed: $FAILED${NC}"
echo -e "${BLUE}📈 Total: $((PASSED + FAILED))${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All tests passed! The script appears to be working correctly.${NC}"
    exit 0
else
    echo -e "\n${RED}⚠️  Some tests failed. Please check the issues above.${NC}"
    exit 1
fi