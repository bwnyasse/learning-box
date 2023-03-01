#!/bin/bash

readonly BASEDIR=$(cd $(dirname $0) && pwd)

# just for the PoC
readonly FIREBASE_PROJECT_NAME='learning-box-369917'

# Since the FIREBASE_PROJECT can have many hosting website, it is 
# a good practice to specify a hosting to use
# That value HOSTING_TARGET_TO_USE is referenced as target in the firebase.json file
readonly HOSTING_TARGET_TO_USE='moviesapp-demo-firebase-remote-config'
readonly HOSTING_SITE_TO_USE='learning-sandox-flutter-moviesapp-demo'

# Need to have fvm & flutter installed on the local machine
fvm flutter build web

# Need to have firebase cli installed on the local machine
firebase use $FIREBASE_PROJECT_NAME

## HOSTING
firebase target:apply hosting $HOSTING_TARGET_TO_USE $HOSTING_SITE_TO_USE
firebase deploy --only hosting 


## REMOTE CONFIG
#echo "Current remote config template"
firebase remoteconfig:get

#echo "remote config versions list"
firebase remoteconfig:versions:list
#firebase deploy --project=$FIREBASE_PROJECT_NAME --only remoteconfig