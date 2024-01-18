#!/usr/bin/env bash

# Set PATH (since crontab does not have the same PATH as general root)
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

THIS_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"

nohup bash "${THIS_DIRECTORY}/update_motd_hint.sh" 1> /dev/null 2>&1 &