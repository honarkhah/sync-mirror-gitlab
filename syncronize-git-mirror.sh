#!/bin/bash
PPPID=`ps h -o ppid= $PPID`
P_COMMAND=`ps h -o %c $PPPID`
# Synchronize Git mirror with a remote repository.
set -u

SCRIPT_FULL_PATH="$(cd "$(dirname "$0")" && pwd)/$(basename "$0" '.sh')"

CONFIGFILE="${SCRIPT_FULL_PATH}.config"

LIBFILE="${SCRIPT_FULL_PATH}.shlib"

LOGFILE="/var/log/$(basename "$0" '.sh').log"
LOCKDIR="${SCRIPT_FULL_PATH}.lock"

TRIGGERED_BY=${1:-fetch}

function include_file()
{
        local THEFILE="$1"

        if [[ ! -r "$THEFILE" ]]
        then
               echo "$THEFILE does not exist or is unreadable" >&2
               exit 1
        fi

        source "$THEFILE"
}

include_file "$CONFIGFILE"
include_file "$LIBFILE"

wait_for_lock "$LOCKDIR" "$LOGFILE"

echo "$(date) $(whoami) $P_COMMAND[$BASHPID]: Updating mirror repository" >> "$LOGFILE"

function fetch_changes()
{
        echo "Fetching changes from $CONF_ORIGIN/$1">> "$LOGFILE"
        git --git-dir "$CONF_GITDIR/$1" remote update --prune >> "$LOGFILE" 2>&1
        check_status "git --git-dir $CONF_GITDIR/$1 remote update --prune" "$LOGFILE"
}

for i in $(cd $CONF_GITDIR && ls -d */ | cut -f1 -d '/'); do
   echo ${i%%/}
   fetch_changes "$i";
done


echo "Updating gitlab was successful." >> "$LOGFILE"
