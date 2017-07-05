# Python

## Main definition

```python
if __name__ == "__main__":
    main()
```

## Program parameters

```python
import sys

print 'Number of arguments:', len(sys.argv), 'arguments.'
# index 0 is the program callname
print 'Argument List:', str(sys.argv)
```

## Read file line by line

```python
file = open("foo.txt", "r")
# with new lines
lines = file.readlines()
# without new lines
lines = file.read().splitlines()
```

## Normalize URL (accents, spaces etc.)

```python
from urllib.parse import quote
url = quote(url, safe="%/:=&?~#+!$,;'@()*[]")
```
