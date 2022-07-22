#!/bin/sh
DATE=`date +%Y-%m-%d`

cd "fullSaves"

FILESAMOUNT=$(ls . | wc -l)
FILESAMOUNT="$(($FILESAMOUNT))"

FILENAME="SAVE_$FILESAMOUNT_$DATE"

mkdir "SAVE_$FILESAMOUNT"

cd "SAVE_$FILESAMOUNT"

echo "Sauvegarde de la base de données"
#SQL DUMP
mysqldump -u glpiuser -pmainpwd glpidb > DB_SAVE.sql

#move into glpi files
cd /var/www/html

echo "Archivage des fichiers"
#tar of files
tar -czvf "/saves/fullSaves/SAVE_$FILESAMOUNT/$DATE.tar.gz" .
echo "Une nouvelle sauvegarde à été enregistrée sous le nom: SAVE_$FILESAMOUNT"
