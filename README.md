# LeetCode Daily Problem Fetcher 🚀

A simple and colorful bash script to fetch and display LeetCode's daily coding challenge directly in your terminal.

The goal of this project is to practice writing tests in a Leetcode style while avoiding the internet for easy answers.
So to get two birds with one stone, an app that pulls the daily challenge and sets up a template file that you must also write the tests for. All in your choice of C#, Python, and Javascript with plans to expand to Java, C, C++, and Rust.

![LeetCode Daily](https://img.shields.io/badge/LeetCode-Daily-orange?style=flat-square&logo=leetcode)
![Bash](https://img.shields.io/badge/Shell-Bash-green?style=flat-square&logo=gnu-bash)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

## ✨ Features

- 🎯 Fetch today's LeetCode daily challenge
- 🎨 Colorful terminal output with emojis
- 🔗 Direct links to problems
- 📝 Clean HTML content parsing
- 🛠️ Easy installation and setup
- 📱 Cross-platform compatibility

## 📋 Requirements

- **curl** (for API requests) - Usually pre-installed
- **jq** (optional, for better JSON formatting)

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

### Option 1: Automatic Installation (Recommended)

```bash
# Clone or download the project
git clone <repository-url> bashscript
cd bashscript

# Run the installer
chmod +x install.sh
./install.sh

# Restart terminal or source your profile
source ~/.bashrc

# Use the command
leetcode-daily
```

### Option 2: Manual Setup

```bash
# Make the script executable
chmod +x leetcode-daily.sh

# Run directly
./leetcode-daily.sh

# Or create an alias manually
echo "alias leetcode-daily='$(pwd)/leetcode-daily.sh'" >> ~/.bashrc
source ~/.bashrc
```

## 📖 Usage

```bash
# Fetch today's daily problem
leetcode-daily

# Show help information
leetcode-daily --help

# Setup alias (if not using installer)
leetcode-daily --setup
```

## 📁 Project Structure

```
bashscript/
├── README.md              # This file
├── leetcode-daily.sh      # Main script
├── install.sh            # Installation script
├── uninstall.sh          # Uninstallation script
├── config/
│   └── settings.conf     # Configuration file
├── docs/
│   ├── USAGE.md         # Detailed usage guide
│   └── API.md           # API documentation
├── examples/
│   └── sample_output.txt # Sample script output
├── tests/
│   └── test_script.sh   # Test suite
└── assets/
    └── screenshots/     # Screenshots
```

## 🎨 Sample Output

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

## 🔧 Configuration

The script uses the LeetCode API endpoint: `https://leetcode-api-pied.vercel.app/daily`

You can modify the configuration in `config/settings.conf` after installation.

## 🧪 Testing

Run the test suite to verify everything works correctly:

```bash
cd tests
chmod +x test_script.sh
./test_script.sh
```

## 🗑️ Uninstallation

```bash
# Run the uninstaller
./uninstall.sh
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🐛 Issues & Support

If you encounter any issues or have suggestions:

1. Check the [docs/](docs/) directory for detailed documentation
2. Run `leetcode-daily --help` for usage information
3. Create an issue in the repository

## 🌟 Acknowledgments

- LeetCode for providing the daily challenges
- The community for feedback and contributions
- [LeetCode API](https://github.com/alfaarghya/LeetCode-API) for the unofficial API

---

**Happy Coding! 🎯**