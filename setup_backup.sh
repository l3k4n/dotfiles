#!/bin/bash

CRON_JOB="0 22 * * 0 ~/cron_dotfile_backup.sh"

if crontab -l | grep -qF "$CRON_JOB"; then
  echo "auto backup already active"
else
  (crontab -l; echo "$CRON_JOB") | crontab -
  echo "auto backup started"
fi

cp -r ./cron_dotfile_backup.sh ~

