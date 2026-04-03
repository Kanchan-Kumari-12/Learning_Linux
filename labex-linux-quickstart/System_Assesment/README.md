# System Assessment & Environment Reconnaissance
Lab: LabEx Corporation | Project Phoenix  |  Env: Linux (Ubuntu)

## Objective
Perform an initial system assessment — verify user identity, audit active sessions, review access controls, and monitor resource usage. Findings documented via output redirection.

### Commands & SOC Relevance
whoami : Confirm active user - Verify authorized access; key first step in IR
uname -a : OS/kernel fingerprint - CVE matching, detect rogue/misconfigured systems
who : List logged-in users - Detect unauthorized sessions / lateral movement
id : UID, GID, group membership - Privilege audit; spot unexpected sudo access
topLive process & resource monitorDetect cryptominers, reverse shells, anomalous spikes
> / >> : Output redirectionCreate audit logs & evidence trail

### MITRE ATT&CK Mapping
System Information Discovery uname :  -a 
Account Discovery : id, who
Valid Accounts : whoami, who
Process Discovery : top

## Key Takeaways

- Identity verified; no unauthorized users detected via who.
- OS/kernel version captured for vulnerability baseline.
- Group memberships confirmed — access control as expected.
- No anomalous process activity observed in top.
- All findings saved to report files using > / >>.
