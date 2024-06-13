#!/bin/bash

# Fichier de log
LOG_FILE="flutter_run.log"

# Exécuter la commande et rediriger les sorties stdout et stderr vers le fichier de log
flutter run -d chrome --debug --verbose 2>&1 | tee "$LOG_FILE"