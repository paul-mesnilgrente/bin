# Bash scripts

## Classic actions

| Action                   | Command                                                              |
|--------------------------|----------------------------------------------------------------------|
| Remove spaces from names | `find <folder> -depth -name "* *" -execdir rename 's/ /_/g' "{}" \;` |

## Add a cron without editing

Current user: `(crontab -l 2>/dev/null; echo "<cron syntax>") | crontab -`
Another user: `(crontab -l 2>/dev/null; echo "<cron syntax>") | crontab -u www-data -`

## Edit music metatag

`ffmpeg -i out.mp3 -metadata title="The Title You Want" -metadata artist="" -metadata album="Name of the Album" -c:a copy out2.mp3`

## Download youtube

Avoid georestriction: `--geo-bypass` or `--geo-bypass-country CODE` Go the channel info page and find the corresponding code [here](https://en.wikipedia.org/wiki/ISO_3166-2)
Avoid OVH blacklist: `--geo-bypass`
Avoid spaces in filenames: `--restrict-filenames`
Download mp3: `--extract-audio --audio-format mp3`
Download playlist: `--yes-playlist` `--playlist-items 1-3,7,10-15`

## PDF

pdftk A=contract.pdf B=signed.pdf cat A1-3 B1 output contract_signed.pdf
