#!/bin/sh

whereis jhead > /dev/null
if [ $? -ne 0 ]; then
    sudo apt install jhead
fi

whereis mencoder > /dev/null
if [ $? -ne 0 ]; then
    sudo apt install mencoder
fi

log.py 'Renommage des photos'
jhead -n%Y%m%d-%H%M%S *.jpg

log.py 'Save file list'
ls -1tr | grep -v files.txt > files.txt

log.py 'Create the video'
mencoder -nosound -noskip -oac copy -ovc copy -o timelapse.avi -mf fps=20 'mf://@files.txt'

log.py '# Génération de la vidéo'
ffmpeg -i timelapse.avi -y -qscale 0 -vf scale=1920:1440,crop=1920:1080 timelapse_rescaled.avi

exit 0
