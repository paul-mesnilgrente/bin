#!/bin/bash

if [ $# -ne 8 ]
then
    echo "Usage : $0 -n <nom_série> -s <numero_saison> -f <fichier_de_nom> -m <y|n>"
    exit 1
fi

i=1
for nom_fichier in *
do
    extension=`echo $nom_fichier | sed 's/.*\.//g'`
    nom_episode=`head -n $i $6 | tail -n 1`
    if [ $i -lt 10 ]
    then
        nouveau_nom=$2" - "$4"x0"$i" - "$nom_episode.$extension
    else
        nouveau_nom=$2" - "$4"x"$i" - "$nom_episode.$extension
    fi
    if [ ${8} = y ]
    then
        echo "moving $nom_fichier -> $nouveau_nom"
        mv "$nom_fichier" "$nouveau_nom"
    else
        echo "$nom_fichier"
        echo "$nouveau_nom"
        echo ""
    fi
    i=`expr $i + 1`
done

if [ ${8} = y ]
then
    rm "$6"
fi

exit 0
