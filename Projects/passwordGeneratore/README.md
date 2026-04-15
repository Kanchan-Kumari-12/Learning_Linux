#  PassGen — Bash Password Generator

A lightweight CLI tool that generates secure, randomized passwords using multi-character set string manipulation in Bash.

---

##  About

Built as part of a Bash scripting project to practice string manipulation, randomness, and input validation in shell scripting. Generates cryptographically-diverse passwords using uppercase, lowercase, digits, and special characters.

---

##  Features

- Multi-character set support (uppercase, lowercase, digits, special chars)
- User-defined password length (8–64 characters)
- Input validation with error handling
- Zero dependencies — pure Bash, runs anywhere

**Example output:**
```
Enter password length (8-64): 16

Generated Password: kR#9mZ!qW2@xLp$7
```

---

##  How It Works

```
ALL_CHARS = UPPERCASE + lowercase + digits + special
│
└── for i in range(LENGTH):
        RAND_INDEX = RANDOM % len(ALL_CHARS)
        PASSWORD  += ALL_CHARS[RAND_INDEX]
```

- `$RANDOM` — Bash built-in that returns a random integer (0–32767)
- `% ${#ALL}` — modulo keeps index within bounds of character set
- `${ALL:$RAND_INDEX:1}` — substring extraction, picks one character

---

##  Security Note

This tool uses Bash's `$RANDOM` which is suitable for general-purpose password generation. For cryptographically secure use cases, consider `/dev/urandom` as an entropy source.

---
