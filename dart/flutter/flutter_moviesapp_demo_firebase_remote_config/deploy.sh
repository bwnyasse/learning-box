#!/bin/bash

readonly BASEDIR=$(cd $(dirname $0) && pwd)
FIREBASE_PROJECT_NAME='drip-tracker'

fvm flutter build web
firebase use $FIREBASE_PROJECT_NAME
firebase deploy --only hosting 
