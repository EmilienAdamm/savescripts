#!/bin/sh

if [ $# -lt 1 ]; then
	echo "Veuillez entrer le numéro de la sauvegarde à restaurer."
	exit
else
	SAVE=$(find /saves/dbSaves/ -type f -wholename $1)

	if [[ "$SAVE1" == "$1"  ]]; then
		echo "Numéro de sauvegarde incorrect."
		exit
	else
		DBPWD="mainpwd"
		DBSAVEPATH="/saves/dbSaves"
		SAVE="/saves/dbSaves/$1"
		echo "Restauration de la base de données"
		/usr/bin/mysql -u glpiuser -p$DBPWD glpidb < "$1"
		echo "La base de donnée à été restaurée."
	fi
fi

