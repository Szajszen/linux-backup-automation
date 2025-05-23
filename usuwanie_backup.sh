#!/bin/bash

FULL_BACKUP_DIR="/home/oem/projekt_ask/tygodniowy_backup"
INCREMENTAL_BACKUP_DIR="/home/oem/projekt_ask/kopia_codzienna"

echo "Usuwanie pełnych kopii zapasowych starszych niż 30 dni..."

find "$FULL_BACKUP_DIR/zrodla" -mindepth 1 -mtime +30 -exec rm -rf {} \;
find "$FULL_BACKUP_DIR/repozytorium_lokalne" -mindepth 1 -mtime +30 -exec rm -rf {} \;
find "$FULL_BACKUP_DIR/repozytorium_zdalne" -mindepth 1 -mtime +30 -exec rm -rf {} \;

echo "Usuwanie kopii przyrostowych starszych niż 30 dni..."

find "$INCREMENTAL_BACKUP_DIR" -name "*.tar.gz" -mtime 3 -exec rm -f {} \;

echo "Usunięto wszystkie kopie starsze niż 30 dni."

