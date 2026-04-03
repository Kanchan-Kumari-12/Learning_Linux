# Lab 04 — File Permissions & Ownership
## What I Learned

Creating files with touch
Changing ownership with chown (including recursive)
Modifying permissions with chmod — both numeric and symbolic notation
Why execute permissions matter for scripts
Difference between numeric and symbolic chmod

## Commands Practiced
bash# --- CHOWN: Change Ownership ---

# Change file owner
chown alice file.txt

# Change owner and group
chown alice:developers file.txt

# Recursive — change ownership of entire directory
chown -R alice:developers projectfolder/

# --- CHMOD: Change Permissions ---

# NUMERIC (OCTAL) NOTATION
# 4 = read (r), 2 = write (w), 1 = execute (x)
# Three digits: owner | group | others

chmod 755 script.sh     # rwxr-xr-x — owner full, group+others read+execute
chmod 644 notes.txt     # rw-r--r--  — owner read+write, others read only
chmod 600 private.key   # rw-------  — owner only, no one else
chmod 777 shared/       # rwxrwxrwx  — full access for everyone (avoid this!)

# SYMBOLIC NOTATION
# u=user/owner, g=group, o=others, a=all
# + add, - remove, = set exactly

chmod +x script.sh          # add execute for everyone
chmod u+x script.sh         # add execute for owner only
chmod g-w file.txt          # remove write from group
chmod o= file.txt           # remove all permissions from others
chmod u=rwx,g=rx,o= dir/    # set exact permissions

# Make a script executable and run it
chmod +x myscript.sh
./myscript.sh

## Permission Reference Table
OctalBinaryPermissionsMeaning7111rwxRead + Write + Execute6110rw-Read + Write5101r-xRead + Execute4100r--Read only0000---No permissions
## Common Permission Patterns
PatternUse casechmod 755Scripts, executableschmod 644Regular files, configschmod 600SSH keys, private fileschmod 700Private directorieschmod 400Read-only sensitive files
## Key Takeaways

Numeric notation is faster once memorized; symbolic is more readable
Without execute (x) permission, a script won't run even if you can read it
sudo is needed to change ownership of files you don't own
Recursive chown -R is powerful — double-check the path before running
Never use chmod 777 in production — opens everything to everyone

## SOC Relevance

Attackers often use chmod +x to make a dropped file executable before running it. Monitoring for chmod calls on unusual files (especially in /tmp/ or /dev/shm/) is a key detection rule in auditd and SIEM systems.
