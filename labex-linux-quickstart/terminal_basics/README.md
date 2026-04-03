# Lab 01 — Terminal Basics & User Identity
## What I Learned

How to open and use the Linux terminal
Using echo to print output to the terminal
Checking user identity with whoami and id
Extracting a specific identity detail using id -un

### Commands Practiced
bash# Print text to terminal
echo "Hello, Linux!"

### Show current logged-in username
whoami

### Show full identity info — UID, GID, and groups
id

### Extract only the username (same as whoami)
id -un
Sample Output
$ whoami
kanchan

$ id
uid=1000(kanchan) gid=1000(kanchan) groups=1000(kanchan),4(adm),27(sudo)

$ id -un
kanchan
## Key Takeaways

whoami → just the username
id → full identity: UID, GID, all group memberships
id -un → username only, useful in scripts where you need just the name
Every Linux user has a UID (User ID) and GID (Group ID)

## SOC Relevance

In incident response, checking id on a suspicious process or session tells you who is running it and what groups they belong to — critical for privilege escalation detection.
