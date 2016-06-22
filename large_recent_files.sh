#!/bin/bash

echo 'Finding the 50 largest files modified in the last day (this may take a while)...'
find ~/ -ctime -1 -ls 2> /dev/null | sort -nr -k7 | head -n50
