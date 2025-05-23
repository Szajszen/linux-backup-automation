#!/bin/bash

SOURCE_DIR="/home/oem/projekt_ask/zrodla"
REPO1_DIR="/home/oem/projekt_ask/repo_git_1"
REPO2_DIR="/home/oem/projekt_ask/repo_git_2"
BACKUP_DIR="/home/oem/projekt_ask/tygodniowy_backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$BACKUP_DIR/zrodla"
mkdir -p "$BACKUP_DIR/repozytorium_lokalne"
mkdir -p "$BACKUP_DIR/repozytorium_zdalne"

tar --preserve-permissions -czf "$BACKUP_DIR/zrodla/zrodla_backup_$TIMESTAMP.tar.gz" -C "$SOURCE_DIR" .

#lokalny git
tar cront -czf "$BACKUP_DIR/repozytorium_lokalne/repo_git_2_backup_$TIMESTAMP.tar.gz" -C "$REPO2_DIR" .

# zdalny git
git clone git@github.com:Szajszen/ask_repo1.git "$REPO1_DIR"
tar --preserve-permissions -czf "$BACKUP_DIR/repozytorium_zdalne/repo_git_1_backup_$TIMESTAMP.tar.gz" -C "$REPO1_DIR" .


#rm -rf "$REPO1_DIR"

echo "Wykonano tygodniowy backup"

