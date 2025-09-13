# PayloadSplitter
A Bash script to split large files into smaller chunks with customizable sizes. Features colored output, progress tracking, and automatic directory organization for efficient file management

# Help panel

```
# ./payloadSplitter.sh
❌ ERROR: Incorrect usage
📋 Usage: ./payloadsplitter.sh original_file.txt payloads_per_file
```

# Usage

```
# ./payloadSplitter.sh wordlist.txt 10
🚀 Starting payload division...
📊 Total payloads: 253
📦 Files to create: 26
🎯 Payloads per file: 10
⏳ Processing...
[====================] 100% (26/26)

✅ Division completed!
📁 Files are located in: payloads/
🎯 Each file contains: 10 payloads
```
