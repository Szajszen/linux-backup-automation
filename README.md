# Linux Backup Automation (Bash)

A short project completed during the **first year of Computer Science studies** for the **Computer Systems Administration** course.  
A Linux-based backup system using Bash scripts, `cron`, `tar`, and `rsync`.

This project implements a fully automated backup solution for files and Git repositories in a Linux environment.  
The system performs regular **weekly full backups** and **daily incremental backups**, supports complete data restoration, and automatically removes old backups after a specified period.

All backup files are stored as compressed `.tar.gz` archives and named using a timestamp for easy identification.  
The backup process preserves file permissions, ownership, and full directory structure, ensuring accurate recovery in case of failure.

The project consists of several Bash scripts that handle full backups, incremental backups, restoration, and cleanup.  
Backup automation is achieved using scheduled tasks configured with `cron`.

## Features

- 🗂️ **Weekly full backups** of:
  - source directories
  - local Git repositories
  - remote GitHub repositories
- 🔁 **Daily incremental backups** using `rsync --link-dest` for space efficiency
- ♻️ **Automatic deletion** of backups older than 30 days
- 💾 **Full restoration** of data from the most recent backup sets
- 📦 **Compression** of all backups into `.tar.gz` archives
- 🕓 **Task scheduling** via `crontab`
- 🔐 **Preservation** of file permissions, metadata, and directory structure
- 🧭 **Timestamp-based filenames** for clear backup identification
- ✅ No external dependencies – works with standard Linux tools
