# LeetCode Daily Problem Generator 🚀

A comprehensive bash script that fetches LeetCode's daily coding challenge and automatically generates solution templates in multiple programming languages.

The goal of this project is to practice writing tests in a LeetCode style while avoiding the internet for easy answers. This tool pulls the daily challenge and sets up template files with proper structure that you must implement and test yourself. Supports C#, Python, and JavaScript with plans to expand to Java, C, C++, and Rust.

Special thanks to the [LeetCode API](https://github.com/noworneverev/leetcode-api) for providing the unofficial API.

![LeetCode Daily](https://img.shields.io/badge/LeetCode-Daily-orange?style=flat-square&logo=leetcode)
![Bash](https://img.shields.io/badge/Shell-Bash-green?style=flat-square&logo=gnu-bash)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

## ✨ Features

- 🎯 **Auto-generate solution templates** in Python, JavaScript, and C#
- 📁 **Organized folder structure** with date-based directories
- 🎨 **Colorful terminal output** with emojis and formatting
- 📝 **Problem description parsing** with clean HTML-to-text conversion
- 🧪 **Test structure setup** for each language
- ⚙️ **Configurable language selection** via settings.conf
- 🔗 **Direct links to LeetCode problems**
- 📱 **Multiple execution modes** (file generation or terminal display)
- 🛠️ **Easy alias setup** for quick access

## 📋 Requirements

- **curl** (for API requests) - Usually pre-installed
- **jq** (for JSON parsing) - **Required** for file generation mode

### Installing jq

```bash
# Ubuntu/Debian
sudo apt install jq

# macOS
brew install jq

# CentOS/RHEL
sudo yum install jq

# Arch Linux
sudo pacman -S jq
```

## 🚀 Quick Start

### Setup

```bash
# Make the script executable
chmod +x leetcode-daily.sh

# Run setup to create alias
./leetcode-daily.sh --setup

# Add the suggested alias to your shell profile
# Then restart terminal or source your profile
source ~/.bashrc
```

### Basic Usage

```bash
# Default: Generate solution files for today's problem
leetcode-daily

# Display problem in terminal only (no files created)
leetcode-daily --terminal

# Show help
leetcode-daily --help
```

## 📖 Usage Modes

### 🎯 File Generation Mode (Default)

Generates a complete workspace for today's LeetCode challenge:

```bash
leetcode-daily
```

**What it creates:**
- Creates `leetcode_problems/` directory (if it doesn't exist)
- Creates date-specific subdirectory (e.g., `leetcode_daily_2024_01_15/`)
- Generates template files for enabled languages:
  - `leetcode_123_two_sum.py` (Python)
  - `leetcode_123_two_sum.js` (JavaScript) 
  - `leetcode_123_two_sum.cs` (C#)

### 🖥️ Terminal Display Mode

View the problem without creating files:

```bash
leetcode-daily --terminal
```

**Features:**
- Clean problem description formatting
- Color-coded difficulty levels
- Direct LeetCode links
- No file system changes

## ⚙️ Configuration

### Language Selection

Create a `settings.conf` file in the same directory as the script:

```bash
# settings.conf
GENERATE_PYTHON=true
GENERATE_JAVASCRIPT=false
GENERATE_CSHARP=true
```

**Default behavior:** If no `settings.conf` exists, all languages are generated.

## 📁 Generated File Structure

```
leetcode_problems/
└── leetcode_daily_2024_01_15/
    ├── leetcode_123_two_sum.py
    ├── leetcode_123_two_sum.js
    └── leetcode_123_two_sum.cs
```

### Template Features

Each generated file includes:
- ✅ **Complete problem description** in comments
- ✅ **Method signature templates** (auto-generated from problem title)
- ✅ **Documentation placeholders** for parameters and return values
- ✅ **Test function structure** ready for implementation
- ✅ **Time/Space complexity placeholders**
- ✅ **Execution output sections** for capturing results

## 🎨 Sample Output

### File Generation Mode
```
🚀 Fetching today's LeetCode daily challenge...

📅 Date: 2024-01-15
🔢 Problem #123: Two Sum
🎯 Difficulty: Easy
🔗 LeetCode Link: https://leetcode.com/problems/two-sum

📋 Summary:
────────────────────────────────────────
📁 Directory: leetcode_daily_2024_01_15
📄 Files created:
  🐍 leetcode_123_two_sum.py
  🟨 leetcode_123_two_sum.js
  🔷 leetcode_123_two_sum.cs

🚀 Next steps:
1. cd leetcode_daily_2024_01_15
2. Edit the files and implement your solutions
3. Customize method signatures and parameters
4. Add test cases from the problem examples
5. Run your solutions and capture output

Happy coding! 🎉
```

### Terminal Display Mode
```
🚀 Fetching today's LeetCode daily challenge...

📅 Date: 2024-01-15
🔢 Problem #123: Two Sum
🟢 Difficulty: Easy
🔗 LeetCode Link: https://leetcode.com/problems/two-sum

📝 Problem Description:
────────────────────────────────────────
Given an array of integers nums and an integer target, 
return indices of the two numbers such that they add up to target.

You may assume that each input would have exactly one solution, 
and you may not use the same element twice.
```

## 🔧 Technical Details

### API Endpoint
Uses: `https://leetcode-api-pied.vercel.app/daily`

### Method Name Generation
- Converts problem titles to camelCase
- Removes special characters and spaces
- Example: "Two Sum" → `twoSum`

### File Naming Convention
Format: `leetcode_{problem_id}_{sanitized_title}.{extension}`

## 🧪 Testing Your Solutions

Each generated file includes a test structure:

```python
# Python example
def test_solution():
    solution = Solution()
    # TODO: Add test cases from problem description
    print("✅ All tests passed!")
```

## 🛠️ Troubleshooting

### Common Issues

1. **"jq not found" error**
   ```bash
   sudo apt install jq  # Ubuntu/Debian
   brew install jq      # macOS
   ```

2. **"Failed to fetch data" error**
   - Check internet connection
   - Verify API endpoint is accessible

3. **Permission denied**
   ```bash
   chmod +x leetcode-daily.sh
   ```

### Dependencies Check
```bash
# Verify requirements
curl --version
jq --version
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Planned Features

- [ ] Java template support
- [ ] C++ template support
- [ ] Rust template support
- [ ] Custom template support
- [ ] Automatic daily pull option
- [ ] Problem history tracking
- [ ] Solution validation

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🐛 Issues & Support

If you encounter any issues:

1. Run `leetcode-daily --help` for usage information
2. Check that `jq` is installed for file generation mode
3. Verify the `settings.conf` format if using custom configuration
4. Create an issue in the repository with error details

## 🌟 Acknowledgments

- [LeetCode](https://leetcode.com/) for providing the daily challenges
- [LeetCode API](https://github.com/noworneverev/leetcode-api) for the unofficial API
- The community for feedback and contributions

---

**Happy Coding! 🎯**
