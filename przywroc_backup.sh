#!/bin/bash

FULL_BACKUP_DIR="/home/oem/projekt_ask/tygodniowy_backup"
INCREMENTAL_BACKUP_DIR="/home/oem/projekt_ask/kopia_codzienna"
SOURCE_FULL_BACKUP_DIR="$FULL_BACKUP_DIR/zrodla"
LOCAL_REPO_FULL_BACKUP_DIR="$FULL_BACKUP_DIR/repozytorium_lokalne"
REMOTE_REPO_FULL_BACKUP_DIR="$FULL_BACKUP_DIR/repozytorium_zdalne"
SOURCE_INCREMENTAL_BACKUP_DIR="$INCREMENTAL_BACKUP_DIR/zrodla"
LOCAL_REPO_INCREMENTAL_BACKUP_DIR="$INCREMENTAL_BACKUP_DIR/repozytorium_lokalne"
REMOTE_REPO_INCREMENTAL_BACKUP_DIR="$INCREMENTAL_BACKUP_DIR/repozytorium_zdalne"

RESTORE_DIR="/home/oem/projekt_ask/zrodla"
REPO2_DIR="/home/oem/projekt_ask/repo_git_2"
REPO1_DIR="/home/oem/projekt_ask/repo_git_1"

# Przywracanie plików źródłowych z pełnej kopii zapasowej
echo "Przywracanie plików źródłowych z paełnej kopii zapasowej..."
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

# Przywracanie plików źródłowych z kopii przyrostowych
echo "Przywracanie plików źródłowych z kopii przyrostowych..."
for INCREMENTAL_BACKUP in $(ls -t $SOURCE_INCREMENTAL_BACKUP_DIR/zrodla_przyrost_*.tar.gz 2>/dev/null); do
  tar -xzf "$INCREMENTAL_BACKUP" -C "$RESTORE_DIR"
  if [ $? -ne 0 ]; then
    echo "Błąd podczas przywracania plików źródłowych z kopii przyrostowej: $INCREMENTAL_BACKUP."
    exit 1
  fi
done

# Przywracanie lokalnego repozytorium Git z pełnej kopii zapasowej
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

# Przywracanie lokalnego repozytorium Git z kopii przyrostowych
echo "Przywracanie lokalnego repozytorium z kopii przyrostowych..."
for INCREMENTAL_BACKUP in $(ls -t $LOCAL_REPO_INCREMENTAL_BACKUP_DIR/repo_git_2_przyrost_*.tar.gz 2>/dev/null); do
  tar -xzf "$INCREMENTAL_BACKUP" -C "$REPO2_DIR"
  if [ $? -ne 0 ]; then
    echo "Błąd podczas przywracania lokalnego repozytorium z kopii przyrostowej: $INCREMENTAL_BACKUP."
    exit 1
  fi
done

# Przywracanie zdalnego repozytorium Git z pełnej kopii zapasowej
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

# Przywracanie zdalnego repozytorium Git z kopii przyrostowych
echo "Przywracanie zdalnego repozytorium z kopii przyrostowych..."
for INCREMENTAL_BACKUP in $(ls -t $REMOTE_REPO_INCREMENTAL_BACKUP_DIR/repo_git_1_przyrost_*.tar.gz 2>/dev/null); do
  tar -xzf "$INCREMENTAL_BACKUP" -C "$REPO1_DIR"
  if [ $? -ne 0 ]; then
    echo "Błąd podczas przywracania zdalnego repozytorium z kopii przyrostowej: $INCREMENTAL_BACKUP."
    exit 1
  fi
done

echo "Przywracanie zakończone sukcesem."

