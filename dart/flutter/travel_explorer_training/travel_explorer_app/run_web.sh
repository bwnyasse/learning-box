#!/bin/bash
# run_web.sh

# Prepare the web files first
./prepare_web.sh

# Then run Flutter
fvm flutter run -d chrome --dart-define-from-file=keys/env.json