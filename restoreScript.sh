#!/bin/bash
#Théorie de restauration
# -> Chercher la sauvegarde demandée
# -> La dézipper
# -> Supprimer le dossier GLPI actuel dans /var/www/html/
# -> Déplacer le fichier dézippé dans /var/www/html avec le nom glpi
# -> remplacer la BDD glpidb par le dump de sauvegarde

if [ $# -eq 0 ];then
	echo "Veuillez donner le type ou le numéro de la sauvegarde à restaurer."
	exit 1
fi

if [ $1 = "i" ] && [ $# -lt 2 ]; then
	echo "Veuillez entrer le chemin de la sauvegarde à restaurer"
fi

if [ "$1" = "i" ] && [  $# -eq 2 ]; then
	INCRSAVEPATH=$2

	#REMOVE CURRENT GLPI FILES
	/usr/bin/rm -rf /var/www/html/glpi
	echo "Suppression des fichiers GLPI actuels"

	#PLACE SAVE IN APACHE FILES
	/usr/bin/mkdir /var/www/html/glpi #Recreate a GLPI folder
	echo "Recréation du fichier GLPI"

	#/usr/bin/cp -r "$INCRSAVEPATH/*" /var/www/html/glpi/
	/usr/bin/rsync -a "$INCRSAVEPATH/" /var/www/html/glpi/
	echo "Déplacement des fichiers de sauvegarde"

	echo "Sauvegarde remise en place"
fi

if [ $# -eq 1 ]; then
	saveNum=$1

	PATH="/saves/fullSaves/SAVE_$saveNum"

	cd "/$PATH"

	GLPIPATH="/var/www/html/glpi"

	#Get the wanted save
	echo "Recherche de la sauvegarde"
	NEWFILES=$(/usr/bin/find . -type f -name '*.tar.gz' -printf "%f\n")

	#Copy of the save to not alter with the actual one
	TEMPFILENAME="SaveToLoad.tar.gz"
	/usr/bin/cp $NEWFILES $TEMPFILENAME

	#Unarchiving the chosen save
	echo "Désarchivage de la sauvegarde"
	/usr/bin//gzip -d /$PATH/$TEMPFILENAME
	TARFILE=$(/usr/bin/find . -type f -name '*.tar' -printf "%f\n")
	cd /usr/bin/ && /usr/bin/tar -xvf /$PATH/$TARFILE -C /saves/rechargeSauvegardes

	#Remove current GLPI files
	echo "Supression des fichiers GLPI actuels"
	/usr/bin/rm -rf GLPIPATH

	#Replace GLPI Files
	echo "Déplacement des fichiers de sauvegarde"
	/usr/bin/rsync -a /saves/rechargeSauvegardes/glpi /var/www/html/

	echo "Suppression des copies de la sauvegarde"
	#Deleted copies of the used save
	/usr/bin/rm -rf /$PATH/SaveToLoad
	/usr/bin/rm -rf /$PATH/SaveToLoad.tar

	#REMOVE EXTRA GLPI CREATED
	/usr/bin/rm -rf /saves/rechargeSauvegardes/glpi

	#Upload DB
	echo "Restitution de la base de données"
	/usr/bin/mysql -u glpiuser -pmainpwd glpidb < "/$PATH/DB_SAVE.sql"

	echo "Sauvegarde remise en place"
fi
