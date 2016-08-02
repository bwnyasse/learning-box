#!/bin/bash
#
# @description Script utilisée pour effectuer des opérations sur un container mongoDB
#
# @author nyasse
##

set -e

################
## FLAG VAR  ##
###############
FLAGS="e:ih"

#Flag e pour l'export
FLAG_E=false

#Flag i pour l'import
FLAG_I=false


################
## GLOBAL VAR ##
###############
REQUIRED_ENV_VAR_TABLE=(MONGO_HOST MONGO_PORT MONGO_BACKUP_FILENAME MONGO_DB_NAME MONGO_COLLECTION_NAME CRON_SCHEDULE)
IS_EXPORT_NO_CRON=false
IS_EXPORT_CRON=false

##############################
## FUNCTIONS DECLARATION  ###
#############################

# Affiche le message d'aide définissant comment utiliser ce script
usage() {
	cat <<-EOF

  Script  pour effectuer des opérations sur uns instance de MongoDB

	OPTIONS:
	========
      -e     Effectue l'export des données en JSON
      -i     Effectue l'import des données JSON
      -h     Affiche ce message d'aide.

	EOF
}


usageExportFeature() {
	cat <<-EOF

  -e pour faire l'export. Options disponibles :

	OPTIONS:
	========
      no-cron   Export instantané sans faire de cron
			cron   Export avec un cron
	EOF
}


function launchImport() {
      /bin/bash ./import.sh
}

function launchExport() {

  CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

	echo "Export will be configured and starting ..."

  if $IS_EXPORT_NO_CRON; then
      # Uniquement si on définit qu'on ne veut pas faire de cron , on lance un export instantané
      /bin/bash ./export.sh
  elif $IS_EXPORT_CRON; then

      LOGFIFO='/var/log/cron.fifo'
      if [[ ! -e "$LOGFIFO" ]]; then
          mkfifo "$LOGFIFO"
      fi
      # Définition des variables pour le cron
			CRON_ENV="MONGO_HOST='$MONGO_HOST'"
			CRON_ENV="$CRON_ENV\nMONGO_PORT='$MONGO_PORT'"
			CRON_ENV="$CRON_ENV\nMONGO_BACKUP_FILENAME='$MONGO_BACKUP_FILENAME'"
			CRON_ENV="$CRON_ENV\nMONGO_DB_NAME='$MONGO_DB_NAME'"
			CRON_ENV="$CRON_ENV\nMONGO_COLLECTION_NAME='$MONGO_COLLECTION_NAME'"
      echo -e "$CRON_ENV\n$CRON_SCHEDULE /export.sh > $LOGFIFO 2>&1" | crontab -
      crontab -l
      # Démarrage du cron
      cron
      tail -f "$LOGFIFO"
  fi
}


function readExportFeatureOption() {
  case $1 in
    no-cron)
        IS_EXPORT_NO_CRON=true
        ;;
		cron)
        IS_EXPORT_CRON=true
        ;;
  	 *)
    		usageExportFeature
    		exit 1
    		;;
  esac
}

function checkEnvVar() {
  for envVar in ${REQUIRED_ENV_VAR_TABLE[@]};
  do
    value=${!envVar}
    [ -z "$value" ] && echo "Erreur: variable $envVar non renseignée." && exit 1;
  done
}

#############################
### Effectif Script build ###
############################

# Vérifie la disponibilité des variables d'environnement nécessaires pour éxecuter le script
for envVar in ${REQUIRED_ENV_VAR_TABLE[@]};
do
	value=${!envVar}
	[ -z "$value" ] && echo "Erreur: variable $envVar non renseignée." && exit 1;
done

# Lecture des input
while getopts $FLAGS OPT;
do
    case $OPT in
        e)
            FLAG_E=true
            readExportFeatureOption "$OPTARG"
            ;;
        i)
            FLAG_I=true
            ;;
        *|h)
            usage
            exit 1
            ;;
    esac
done


## Launch operations
if $FLAG_I; then
    launchImport
fi

if $FLAG_E; then
    launchExport
fi
