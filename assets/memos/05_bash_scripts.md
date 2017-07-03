# Bash scripts

## Remove spaces from a folder

```bash
find -name "* *" -type d | rename 's/ /_/g'
find -name "* *" -type f | rename 's/ /_/g'
```
