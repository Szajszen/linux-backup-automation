#!/bin/bash
INCREMENTAL_BACKUP_DIR="/home/oem/projekt_ask/kopia_codzienna"
RESTORE_DIR="/home/oem/projekt_ask/zrodla"
REPO2_DIR="/home/oem/projekt_ask/repo_git_2"
REPO1_DIR="/home/oem/projekt_ask/repo_git_1"

# najnowsa kopia
LATEST_INCREMENTAL_BACKUP=$(ls -t $INCREMENTAL_BACKUP_DIR/backup_*.tar.gz 2>/dev/null | head -n 1)

if [ -z "$LATEST_INCREMENTAL_BACKUP" ]; then
  echo "Błąd: Nie znaleziono kopii przyrostowej."
  exit 1
fi

# tymczasowy katalog kopii przyrostowej
TMP_RESTORE_DIR="/tmp/restore_tmp"
rm -rf $TMP_RESTORE_DIR
mkdir -p $TMP_RESTORE_DIR

echo "Rozpakowywanie najnowszej kopii przyrostowej: $LATEST_INCREMENTAL_BACKUP"
tar -xzf "$LATEST_INCREMENTAL_BACKUP" -C "$TMP_RESTORE_DIR"
if [ $? -ne 0 ]; then
  echo "Błąd podczas rozpakowywania kopii przyrostowej: $LATEST_INCREMENTAL_BACKUP."
  exit 1
fi

echo "Przywracanie plików źródłowych z kopii przyrostowej..."
rm -rf $RESTORE_DIR/*
mkdir -p $RESTORE_DIR
rsync -a "$TMP_RESTORE_DIR/current/" "$RESTORE_DIR"
if [ $? -ne 0 ]; then
  echo "Błąd podczas przywracania plików źródłowych."
  exit 1
fi

# lokalny GIT
echo "Przywracanie lokalnego repozytorium Git z kopii przyrostowej..."
rm -rf $REPO2_DIR/*
mkdir -p $REPO2_DIR
rsync -a "$TMP_RESTORE_DIR/current_repo_git_2/" "$REPO2_DIR"
if [ $? -ne 0 ]; then
  echo "Błąd podczas przywracania lokalnego repozytorium Git."
  exit 1
fi

# Zdalny GIT
echo "Przywracanie zdalnego repozytorium Git z kopii przyrostowej..."
rm -rf $REPO1_DIR/*
mkdir -p $REPO1_DIR
rsync -a "$TMP_RESTORE_DIR/repo_git_1/" "$REPO1_DIR"
if [ $? -ne 0 ]; then
  echo "Błąd podczas przywracania zdalnego repozytorium Git."
  exit 1
fi

rm -rf $TMP_RESTORE_DIR

echo "Przywracanie z kopii przyrostowej zakończone sukcesem."

