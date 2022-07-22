#!/bin/sh

DATE=`/usr/bin/date +%Y-%m-%d`

cd dbSaves/

FILESAMOUNT=$(ls . | wc -l)

FILENAME="DB_SAVE_${DATE}_${FILESAMOUNT}"

/usr/bin/mysqldump -u glpiuser -pmainpwd glpidb > "$FILENAME.sql"

echo "La base de données à été sauvegardée sous le nom: $FILENAME."
