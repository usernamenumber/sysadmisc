#!/bin/bash
# Script to run frequently via cron and report system info during CPU spikes
# Originally written to troubleshoot Moodle performance problems,
# hence the PHP/Apache-centric checks.
#
# For original source and to suggest patches:
# https://github.com/usernamenumber/sysadmisc
#

# Comment these out to skip log dumps
APACHE_ACCESS_LOG="/var/log/apache2/access_log"
APACHE_ERROR_LOG="/var/log/apache2/error_log"

# Exit if another instance is running, or if load average isn't high
[ $(pgrep $(basename $0) | wc -l) -gt 1 ] && exit
U=$(uptime | sed 's,.*load average: ,,' | tr -d , | awk '$1 > .95')
[ -z "$U" ] && exit

echo "Load Average: $U"
echo "*** START ***" ; date ; echo "" 
echo "=== PHP INSTANCES ===" ; ps axo '%cpu %mem user pid args' | grep php5 | grep -v grep ; echo ""
for p in $(ps axo '%cpu %mem user pid args' | grep php5 | grep -v grep | awk '{print $4}'); do echo "== LSOF for pid $p =="; lsof -p $p; echo ""; done
echo "=== BIGGEST CPU USERS ===" ; ps axo '%cpu pid args' | tail -n +2 |  sort -rn | head ; echo ""
echo "=== BIGGEST MEM USERS ===" ; ps axo '%mem pid args' | tail -n +2 |  sort -rn | head ; echo ""
echo "=== TOP ===" ;  TERM=vt100 top -b -n 1 ; echo ""

(
    (X=$(vmstat -n 10 12) ; echo "=== VMSTAT ===" ; echo "$X" ; echo "")&
    (sleep 5; X=$(iostat -dmxz 10 12) ; echo "=== IOSTAT ===" ; echo "$X" ; echo "")&
    ([ -z "$APACHE_ACCESS_LOG" ] || (X=$(sleep 122 ; tail $APACHE_ACCESS_LOG) ; echo "==== ACCESS LOG ===" ; echo "$X"; echo ""))&
    ([ -z "$APACHE_ERROR_LOG" ]  || (X=$(sleep 124 ; tail $APACHE_ERROR_LOG)  ; echo "==== ERROR LOG ==="  ; echo "$X"; echo ""))&
    wait
)

echo "*** END ***" ; date ; echo "" 
echo "=== PHP CHECK ===" ; ps axo '%cpu %mem user pid args' | grep php5 | grep -v grep ; echo ""
echo "=== BIGGEST CPU USERS ===" ; ps axo '%cpu pid args' | tail -n +2 |  sort -rn | head ; echo ""
echo "=== BIGGEST MEM USERS ===" ; ps axo '%mem pid args' | tail -n +2 |  sort -rn | head ; echo ""
echo "=== TOP ===" ;  TERM=vt100 top -b -n 1 ; echo ""
