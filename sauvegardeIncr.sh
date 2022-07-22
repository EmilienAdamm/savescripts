#!/bin/bash

GLPIPATH="/var/www/html/glpi/"

SAVESPATH="/saves/rechargeSauvegardes"

BACKUPNUMBER=5 #Number to edit to have more save files

/usr/bin/rm -rf "$SAVESPATH/backup.$BACKUPNUMBER"

while [[ $BACKUPNUMBER -gt 0 ]]; do
	ONELOWER=$(($BACKUPNUMBER - 1))
	/usr/bin/mv "$SAVESPATH/backup.$ONELOWER" "$SAVESPATH/backup.$BACKUPNUMBER"

	((BACKUPNUMBER -= 1))
done

/usr/bin/cp -al "$SAVESPATH/backup.0" "$SAVESPATH/backup.1"

/usr/bin/rsync -a --delete $GLPIPATH "$SAVESPATH/backup.0"
echo "Sauvegarde incrémentielle réalisée"













