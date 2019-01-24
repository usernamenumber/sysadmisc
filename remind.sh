#!/bin/bash

# USAGE: any of the following invocations work
## remind.sh 10m do something in ten minutes
## remind.sh 13:00 do someting at 1pm
## remind.sh do something in one hour (default)
## remind.sh 2h  # default reminder in two hours
## remind.sh     # default reminder in one hour

# Default reminder time
T=1h 

## Check for a time descriptor in the first argument
# Relative time
if [[ "$1" =~ ^[0-9]+\s*[mhsd]?$ ]] ; then
    T=$1 ; shift

# Absolute time, which we'll convert to relative minutes
elif [[ "$1" =~ ^[0-9:]+(am|pm|[ap]|)$ ]] ; then
    T=$1 ; shift

    # Convert "HH:MMa" to "HH:MM am, so `date` can parse it"
    [[ "$T" =~ [ap]$ ]] && T=$(echo $T | sed 's,\s*\([ap]\)\s*$, \1m,')

    # Convert time to minutes-from-now
    T=$[ ($(date +%s -d "$T") - $(date +%s)) / 60 ]"m"
fi

notify-send "Reminder set for $T from now..."
(sleep ${T} ; notify-send -u critical "REMINDER" "$@") &
