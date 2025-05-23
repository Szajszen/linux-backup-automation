#!/bin/bash
FULL_BACKUP_DIR="/home/oem/projekt_ask/tygodniowy_backup"
SOURCE_FULL_BACKUP_DIR="$FULL_BACKUP_DIR/zrodla"
LOCAL_REPO_FULL_BACKUP_DIR="$FULL_BACKUP_DIR/repozytorium_lokalne"
REMOTE_REPO_FULL_BACKUP_DIR="$FULL_BACKUP_DIR/repozytorium_zdalne"

RESTORE_DIR="/home/oem/projekt_ask/zrodla"
REPO2_DIR="/home/oem/projekt_ask/repo_git_2"
REPO1_DIR="/home/oem/projekt_ask/repo_git_1"

echo "Przywracanie plików źródłowych z pełnej kopii zapasowej..."
LATEST_FULL_SOURCE_BACKUP=$(ls -t $SOURCE_FULL_BACKUP_DIR/zrodla_backup_*.tar.gz 2>/dev/null | head -n 1)

if [ -z "$LATEST_FULL_SOURCE_BACKUP" ]; then
  echo "Błąd: Nie znaleziono pełnej kopii zapasowej plików źródłowych."
  exit 1
fi

mkdir -p $RESTORE_DIR
tar -xzf "$LATEST_FULL_SOURCE_BACKUP" -C "$RESTORE_DIR"

if [ $? -ne 0 ]; then
  echo "Błąd podczas przywracania plików źródłowych z pełnej kopii zapasowej."
  exit 1
fi

# LOKALNY GIT
echo "Przywracanie lokalnego repozytorium z pełnej kopii zapasowej..."
LATEST_FULL_LOCAL_REPO_BACKUP=$(ls -t $LOCAL_REPO_FULL_BACKUP_DIR/repo_git_2_backup_*.tar.gz 2>/dev/null | head -n 1)

if [ -z "$LATEST_FULL_LOCAL_REPO_BACKUP" ]; then
  echo "Błąd: Nie znaleziono pełnej kopii zapasowej lokalnego repozytorium."
  exit 1
fi

rm -rf $REPO2_DIR
mkdir -p $REPO2_DIR
tar -xzf "$LATEST_FULL_LOCAL_REPO_BACKUP" -C "$REPO2_DIR"

if [ $? -ne 0 ]; then
  echo "Błąd podczas przywracania lokalnego repozytorium z pełnej kopii zapasowej."
  exit 1
fi

# ZDALNY GIT
echo "Przywracanie zdalnego repozytorium z pełnej kopii zapasowej..."
LATEST_FULL_REMOTE_REPO_BACKUP=$(ls -t $REMOTE_REPO_FULL_BACKUP_DIR/repo_git_1_backup_*.tar.gz 2>/dev/null | head -n 1)

if [ -z "$LATEST_FULL_REMOTE_REPO_BACKUP" ]; then
  echo "Błąd: Nie znaleziono pełnej kopii zapasowej zdalnego repozytorium."
  exit 1
fi

rm -rf $REPO1_DIR
mkdir -p $REPO1_DIR
tar -xzf "$LATEST_FULL_REMOTE_REPO_BACKUP" -C "$REPO1_DIR"

if [ $? -ne 0 ]; then
  echo "Błąd podczas przywracania zdalnego repozytorium z pełnej kopii zapasowej."
  exit 1
fi

echo "Przywracanie z pełnej kopii zapasowej zakończone sukcesem."

