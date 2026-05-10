# Lexical and Syntax Based Security Analyzer for Bash Scripts

The Bash Script Analyzer is a Complex Computing Problem (CCP) Project that performs static analysis of Bash scripts using lexical and syntax analysis. It helps detect potentially unsafe or malicious commands before execution, improving script safety and reliability.

It demonstrates how compiler design concepts can be applied to cybersecurity and static code analysis. Since Bash is widely used as the default shell in Linux systems and critical servers, this tool acts as a safe debugging layer to identify errors and risky commands before they are executed.

## 🎯 Objectives
1. Perform lexical analysis of Bash scripts using Flex
2. Perform syntax analysis using Bison
3. Detect unsafe or suspicious commands in scripts
4. Generate a token table and error reports
5. Identify malicious patterns commonly used in attacks

## ⚙️ Features

### 🔍 Lexical Analysis
- Tokenizes Bash scripts into meaningful components
- Identifies:
  - Keywords (`if`, `then`, `fi`, etc.)
  - Commands (`rm`, `wget`, `curl`, etc.)
  - Operators and symbols
  - Variables and strings

### 🧠 Syntax Analysis
- Validates Bash grammar rules
- Detects syntax errors in script structure
- Ensures proper command formatting

### 🚨 Threat Detection

The analyzer flags potentially dangerous commands such as:
- `rm -rf /`
- `wget` / `curl` (suspicious downloads)
- `chmod 777`
- `eval`
- `fork bombs (:(){:|:&};:)`
- `nc (netcat misuse)`
- Redirection-based attacks (`> /dev/sda`)

## 🧰 Technologies Used
- Flex (Lexical Analyzer Generator)
- Bison (Parser Generator)
- Bash Scripting (Test Inputs)
- Linux Environment (WSL / Ubuntu recommended)

## ▶️ How to Run

1. Install dependencies

```
sudo apt update
sudo apt install flex bison gcc
```
2. Compile the project
```
flex lexer.l
bison -d parser.y
gcc lex.yy.c parser.tab.c -o analyzer
```
3. Run analyzer

You can run without compiling as the executable file is already in the source code.

```
./analyzer test.sh
```

## 🔐 Security Use Case

This project demonstrates how compiler design techniques can be used for:
- Static analysis of shell scripts
- Pre-execution security validation
- Preventing execution of unsafe commands

## ⚠️ Limitations

- Bash is a very large and complex language, but this analyzer only covers a limited subset of its grammar and commands.
- It focuses mainly on static patterns, so advanced Bash features (dynamic evaluations) may not be fully analyzed.
- It cannot reliably detect highly obfuscated or encoded malicious commands.
- Detection depends on a predefined rule set, which may lead to false positives or false negatives.
