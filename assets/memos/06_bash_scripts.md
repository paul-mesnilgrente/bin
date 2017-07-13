# Bash scripts

## Classic actions

| Action                   | Command                                                            |
|--------------------------|--------------------------------------------------------------------|
| Remove spaces from names | find <folder> -depth -name "* *" -execdir rename 's/ /_/g' "{}" \; |

## Add a cron without editing

Current user: (crontab -l 2>/dev/null; echo "<cron syntax>") | crontab -
Another user: (crontab -l 2>/dev/null; echo "<cron syntax>") | crontab -u www-data -

## Edit music metatag

ffmpeg -i out.mp3 -metadata title="The Title You Want" -metadata artist="" -metadata album="Name of the Album" -c:a copy out2.mp3
