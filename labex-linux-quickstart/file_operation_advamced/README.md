# Lab 03 — File Operations (Advanced Practice)
## What I Learned
Deepened practice on the same file operation commands from Lab 02 with more complex scenarios:

Multi-level directory navigation
Bulk file operations
Understanding ls output in detail
Safe deletion practices

## Commands Practiced
bash# Reading ls -l output
# Format: permissions | links | owner | group | size | date | name
# Example:
# -rw-r--r-- 1 kanchan kanchan 1024 Jan 10 10:30 notes.txt
#  ^          ^         ^        ^
#  file type  hard links owner   size in bytes

# Create multiple files at once
touch file1.txt file2.txt file3.txt

# Copy multiple files into a directory
cp file1.txt file2.txt file3.txt destination/

# Move multiple files
mv *.txt archive/      # wildcard — moves all .txt files

# Safer deletion — check before deleting
ls -la myfolder/       # confirm contents first
rm -ri myfolder/       # -i flag = interactive, asks before each delete

# Explore command options via man pages
man ls
man rm
man cp

## Understanding ls -l Output
FieldMeaning-rw-r--r--Permissions (file type + owner/group/others)1Number of hard linkskanchanOwnerkanchanGroup1024Size in bytesJan 10 10:30Last modified timenotes.txtFilename
### Key Takeaways

man <command> is your best friend — full documentation always available offline
Wildcards (*, ?) make bulk operations fast
Always ls before rm -r — confirm what you're about to delete
rm -i adds a safety prompt — good habit when unsure

## SOC Relevance

Log files in /var/log/ follow this exact structure. Reading ls -lh /var/log/auth.log quickly tells you when the auth log was last modified — a timestamp anomaly can indicate log tampering.
