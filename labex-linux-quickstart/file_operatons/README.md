# Lab 02 — File System Navigation & File Operations
## What I Learned

Navigating the filesystem with cd and pwd
Creating files and directories with touch and mkdir
Listing contents with ls and its options
Copying with cp, moving/renaming with mv
Deleting with rm and rmdir

### Commands Practiced
bash# Print current working directory
pwd

### Change directory
cd /home/kanchan
cd ..       # go up one level
cd ~        # go to home directory
cd -        # go to previous directory

### Create an empty file
touch notes.txt

### Create a directory
mkdir myfolder
mkdir -p parent/child/grandchild   # create nested dirs at once

### List files
ls
ls -l       # long format with permissions, size, date
ls -la      # include hidden files (dotfiles)
ls -lh      # human-readable file sizes

### Copy files and directories
cp file.txt backup.txt
cp -r myfolder/ myfolder_backup/   # recursive copy for directories

### Move or rename
mv file.txt /tmp/file.txt          # move
mv oldname.txt newname.txt         # rename

### Delete
rm file.txt
rm -r myfolder/                    # recursive delete directory
rmdir emptyfolder/                 # only works on empty directories
Key Takeaways

pwd always tells you where you are — use it often
mkdir -p saves time when creating nested directories
ls -la is the most useful variant — shows everything including hidden files
rm is permanent — no Recycle Bin in Linux, deleted = gone
mv doubles as a rename command (move to same location, new name)

## SOC Relevance

Analysts navigate log directories (/var/log/), copy evidence files without modifying originals (cp), and check directory contents (ls -la) during investigations. Hidden files (dotfiles) are often used by attackers to hide malicious scripts.
