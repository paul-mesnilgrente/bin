#!/bin/sh

echo "############################################"
echo "# Redimensionnement des photos             #"
echo "############################################"
i=1
for FILE in `ls *.JPG`; do
    mogrify -resize 1920x $FILE;
    echo $i - $FILE;
    i=`expr $i + 1`
done

echo "############################################"
echo "# Génération de la vidéo                   #"
echo "############################################"
# ffmpeg -start_number 0016709 -i G%07d.JPG -c:v libx264 -pix_fmt yuv420p timelapse.mp4

exit 0
