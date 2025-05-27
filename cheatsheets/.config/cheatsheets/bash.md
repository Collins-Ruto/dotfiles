# 🐚 Comprehensive Bash Cheatsheet

> *Your complete reference for command-line mastery*

---

## 📁 File & Directory Operations

### Basic Navigation

| Command | Description |
|---------|-------------|
| `pwd` | Print current directory |
| `cd /path` | Change to specific directory |
| `cd ~` or `cd` | Go to home directory |
| `cd -` | Go to previous directory |
| `cd ..` | Go up one directory |
| `cd ../..` | Go up two directories |

### Listing Files

| Command | Description |
|---------|-------------|
| `ls` | List files and directories |
| `ls -l` | Long format listing |
| `ls -la` | List all files with details (including hidden) |
| `ls -lh` | Human-readable file sizes |
| `ls -lt` | Sort by modification time |
| `ls -lS` | Sort by file size |
| `ls -R` | Recursive listing |
| `tree` | Display directory tree structure |

### File Operations

| Command | Description |
|---------|-------------|
| `touch file.txt` | Create empty file or update timestamp |
| `cp file1 file2` | Copy file |
| `cp -r dir1 dir2` | Copy directory recursively |
| `cp -i file1 file2` | Copy with confirmation prompt |
| `mv file1 file2` | Move/rename file |
| `mv file1 /path/` | Move file to directory |
| `rm file.txt` | Remove file |
| `rm -r directory` | Remove directory recursively |
| `rm -rf directory` | Remove recursively and forcefully |
| `rm -i file.txt` | Remove with confirmation |

### Directory Operations

| Command | Description |
|---------|-------------|
| `mkdir directory` | Create directory |
| `mkdir -p path/to/dir` | Create nested directories |
| `rmdir directory` | Remove empty directory |
| `du -sh` | Show directory size (human-readable) |
| `du -ah` | Show all file/directory sizes |
| `df -h` | Show disk space usage |

---

## 🔍 Finding & Searching

### Find Files

| Command | Description |
|---------|-------------|
| `find . -name "*.txt"` | Find files by name pattern |
| `find . -type f` | Find only files |
| `find . -type d` | Find only directories |
| `find . -size +1M` | Find files larger than 1MB |
| `find . -mtime -7` | Find files modified in last 7 days |
| `find . -user username` | Find files by owner |
| `find . -exec rm {} \;` | Find and execute command |
| `locate filename` | Quick file search (uses database) |
| `which command` | Find location of command |
| `whereis command` | Find binary, source, manual |

### Search in Files

| Command | Description |
|---------|-------------|
| `grep "pattern" file.txt` | Search for pattern in file |
| `grep -r "pattern" .` | Search recursively in directory |
| `grep -i "pattern" file` | Case-insensitive search |
| `grep -n "pattern" file` | Show line numbers |
| `grep -v "pattern" file` | Invert match (exclude pattern) |
| `grep -c "pattern" file` | Count matching lines |
| `grep -l "pattern" *.txt` | List files containing pattern |
| `grep -A 3 -B 3 "pattern"` | Show 3 lines before/after match |

---

## 📝 Text Processing & Manipulation

### File Content

| Command | Description |
|---------|-------------|
| `cat file.txt` | Display file content |
| `less file.txt` | View file with pagination |
| `more file.txt` | View file page by page |
| `head file.txt` | Show first 10 lines |
| `head -n 20 file.txt` | Show first 20 lines |
| `tail file.txt` | Show last 10 lines |
| `tail -f file.txt` | Follow file changes (live) |
| `tail -n 50 file.txt` | Show last 50 lines |

### Text Manipulation

| Command | Description |
|---------|-------------|
| `sort file.txt` | Sort lines alphabetically |
| `sort -n file.txt` | Sort numerically |
| `sort -r file.txt` | Reverse sort |
| `uniq file.txt` | Remove duplicate lines |
| `sort file.txt \| uniq` | Sort and remove duplicates |
| `wc file.txt` | Count lines, words, characters |
| `wc -l file.txt` | Count lines only |
| `cut -d',' -f1 file.csv` | Extract first column (CSV) |
| `tr 'a-z' 'A-Z' < file.txt` | Convert to uppercase |

### Advanced Text Processing

| Command | Description |
|---------|-------------|
| `sed 's/old/new/g' file.txt` | Replace all occurrences |
| `sed -i 's/old/new/g' file.txt` | Replace in-place |
| `sed -n '1,10p' file.txt` | Print lines 1-10 |
| `awk '{print $1}' file.txt` | Print first column |
| `awk -F',' '{print $2}' file.csv` | Print second column (CSV) |
| `awk '/pattern/ {print}' file` | Print lines matching pattern |
| `awk '{sum+=$1} END {print sum}'` | Sum first column |

---

## 🔧 Process Management

### Process Information

| Command | Description |
|---------|-------------|
| `ps` | Show running processes |
| `ps aux` | Show all processes with details |
| `ps -ef` | Full format process listing |
| `pstree` | Show process tree |
| `top` | Real-time process monitor |
| `htop` | Enhanced process monitor |
| `jobs` | List background jobs |
| `pgrep process_name` | Find process ID by name |

### Process Control

| Command | Description |
|---------|-------------|
| `kill PID` | Terminate process (SIGTERM) |
| `kill -9 PID` | Force kill process (SIGKILL) |
| `killall process_name` | Kill all processes by name |
| `pkill process_name` | Kill processes by name |
| `Ctrl+C` | Interrupt current process |
| `Ctrl+Z` | Suspend current process |
| `bg` | Put last job in background |
| `fg` | Bring last job to foreground |
| `bg %1` | Put job 1 in background |
| `fg %1` | Bring job 1 to foreground |

### Background Processes

| Command | Description |
|---------|-------------|
| `command &` | Run command in background |
| `nohup command &` | Run immune to hangups |
| `nohup command > output.log 2>&1 &` | Background with logging |
| `disown %1` | Remove job from shell's job table |
| `screen` | Create detachable session |
| `tmux` | Terminal multiplexer |

---

## 🌐 Network & System Info

### Network Commands

| Command | Description |
|---------|-------------|
| `ping google.com` | Test network connectivity |
| `wget url` | Download file from URL |
| `curl url` | Transfer data from server |
| `curl -o file.txt url` | Download and save as file |
| `scp file.txt user@host:/path` | Secure copy to remote |
| `ssh user@hostname` | Connect via SSH |
| `netstat -tuln` | Show listening ports |
| `ss -tuln` | Modern netstat alternative |

### System Information

| Command | Description |
|---------|-------------|
| `uname -a` | System information |
| `hostname` | Display system hostname |
| `whoami` | Current username |
| `id` | User and group IDs |
| `uptime` | System uptime and load |
| `date` | Current date and time |
| `cal` | Display calendar |
| `free -h` | Memory usage (human-readable) |
| `lscpu` | CPU information |
| `lsblk` | List block devices |

---

## 🔒 Permissions & Ownership

### File Permissions

| Command | Description |
|---------|-------------|
| `ls -l` | Show file permissions |
| `chmod 755 file.txt` | Set permissions (rwxr-xr-x) |
| `chmod +x script.sh` | Add execute permission |
| `chmod -w file.txt` | Remove write permission |
| `chmod u+x file.txt` | Add execute for user |
| `chmod g-w file.txt` | Remove write for group |
| `chmod o+r file.txt` | Add read for others |

### Ownership

| Command | Description |
|---------|-------------|
| `chown user file.txt` | Change file owner |
| `chown user:group file.txt` | Change owner and group |
| `chgrp group file.txt` | Change group ownership |
| `sudo chown -R user:group /path` | Recursive ownership change |

---

## 🔗 Input/Output & Redirection

### Redirection

| Command | Description |
|---------|-------------|
| `command > file.txt` | Redirect output to file (overwrite) |
| `command >> file.txt` | Redirect output to file (append) |
| `command < file.txt` | Use file as input |
| `command 2> error.log` | Redirect errors to file |
| `command &> all.log` | Redirect output and errors |
| `command 2>&1` | Redirect errors to stdout |

### Pipes

| Command | Description |
|---------|-------------|
| `command1 \| command2` | Pipe output to next command |
| `ls -l \| grep ".txt"` | List files and filter |
| `ps aux \| grep process` | Find specific process |
| `cat file.txt \| sort \| uniq` | Chain multiple commands |
| `history \| tail -20` | Show last 20 commands |

---

## 📚 History & Shortcuts

### Command History

| Command | Description |
|---------|-------------|
| `history` | Show command history |
| `history \| grep command` | Search command history |
| `!!` | Execute last command |
| `!n` | Execute command number n |
| `!string` | Execute last command starting with string |
| `^old^new` | Replace in last command |
| `Ctrl+R` | Reverse search history |

### Keyboard Shortcuts

| Shortcut | Description |
|----------|-------------|
| `Ctrl+A` | Move to beginning of line |
| `Ctrl+E` | Move to end of line |
| `Ctrl+U` | Clear line before cursor |
| `Ctrl+K` | Clear line after cursor |
| `Ctrl+W` | Delete word before cursor |
| `Ctrl+L` | Clear screen |
| `Ctrl+D` | Exit shell (EOF) |
| `Tab` | Auto-complete |
| `Tab Tab` | Show all completions |

---

## 🔢 Variables & Environment

### Environment Variables

| Command | Description |
|---------|-------------|
| `echo $HOME` | Display home directory |
| `echo $PATH` | Display PATH variable |
| `env` | Show all environment variables |
| `export VAR=value` | Set environment variable |
| `unset VAR` | Remove variable |
| `which bash` | Find bash location |
| `echo $SHELL` | Current shell |
| `echo $$` | Current shell PID |

### Script Variables

| Command | Description |
|---------|-------------|
| `$0` | Script name |
| `$1, $2, ...` | Script arguments |
| `$#` | Number of arguments |
| `$@` | All arguments |
| `$?` | Exit status of last command |
| `$$` | Process ID |

---

## 🗜️ Archives & Compression

### Tar Archives

| Command | Description |
|---------|-------------|
| `tar -cvf archive.tar files/` | Create tar archive |
| `tar -xvf archive.tar` | Extract tar archive |
| `tar -tvf archive.tar` | List archive contents |
| `tar -czvf archive.tar.gz files/` | Create compressed archive |
| `tar -xzvf archive.tar.gz` | Extract compressed archive |

### Compression

| Command | Description |
|---------|-------------|
| `gzip file.txt` | Compress file |
| `gunzip file.txt.gz` | Decompress file |
| `zip archive.zip files/` | Create zip archive |
| `unzip archive.zip` | Extract zip archive |
| `7z a archive.7z files/` | Create 7z archive |

---

## 💡 Pro Tips & Advanced

### Useful Combinations

| Command | Description |
|---------|-------------|
| `ls -la \| grep "^d"` | List only directories |
| `find . -name "*.log" -delete` | Find and delete log files |
| `ps aux \| grep -v grep \| grep process` | Clean process search |
| `du -sh * \| sort -hr` | Show directory sizes sorted |
| `netstat -tuln \| grep :80` | Check if port 80 is open |

### One-liners

| Command | Description |
|---------|-------------|
| `for f in *.txt; do echo $f; done` | Loop through files |
| `find . -type f -exec grep -l "pattern" {} \;` | Find files with pattern |
| `sed -i 's/\r$//' file.txt` | Remove Windows line endings |
| `awk '{print NF}' file.txt` | Count fields per line |
| `sort file.txt \| uniq -c \| sort -nr` | Count and sort duplicates |

---

## 🚀 Productivity Boosters

### Aliases (add to ~/.bashrc)

```bash
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias h='history'
alias c='clear'
```

### Useful Functions

```bash
# Extract any archive
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
```

---

> *Master these commands and you'll be a Bash power user! 🎯✨*
