#!/bin/bash

readonly BASEDIR=$(cd $(dirname $0) && pwd)

# just for the PoC
readonly FIREBASE_PROJECT_NAME='learning-box-369917'

# Since the FIREBASE_PROJECT can have many hosting website, it is 
# a good practice to specify a hosting to use
# That value HOSTING_TARGET_TO_USE is referenced as target in the firebase.json file
readonly HOSTING_TARGET_TO_USE='ui'
readonly HOSTING_SITE_TO_USE='learning-box-flutter-invoice-documentai'

# Need to have fvm & flutter installed on the local machine
fvm flutter build web --web-renderer html

# Need to have firebase cli installed on the local machine
firebase use $FIREBASE_PROJECT_NAME

## HOSTING
firebase target:apply hosting $HOSTING_TARGET_TO_USE $HOSTING_SITE_TO_USE
firebase deploy --only hosting 

