#!/bin/bash

REGION='us-east-1'
REF_TIME=$(date +'%H:%M:%S %Z %Y-%m-%d')
MINS_BEFORE=10
MINS_AFTER=0
MODE='search'
PATTERN=''

OPTSTRING="r:g:t:b:a:m:p:h"

usage() {
  cat <<EOF >&2 
USAGE: $(basename $0) [options...]
  -m MODE        | "search" (or "s") or "tail" (or "t") (default: $MODE) 
  -r REGION      | (default: $REGION)
  -g LOG_GROUP   | logGroup name 
  -p PATTERN     | only show logs matching pattern (default: empty)  

  (seach mode only)
  -t REF_TIME    | (default: current time)
  -b MINS_BEFORE | show logs from up to this many mins before REF_TIME (default: $MINS_BEFORE)  
  -a MINS_AFTER  | show logs from up to this many mins after REF_TIME (default: $MINS_AFTER) 

Any extra arguments are passed to the AWS command

EOF
}



while getopts ${OPTSTRING} opt; do
  case ${opt} in
    r)
      REGION=${OPTARG}
      ;;
    g)
      LOG_GROUP=${OPTARG}
      ;;
    t)
      REF_TIME=${OPTARG}
      ;;
    a)
      MINS_AFTER=${OPTARG}
      ;;
    b)
      MINS_BEFORE=${OPTARG}
      ;;
    m)
      MODE=${OPTARG}
      ;;
    p)
      PATTERN=${OPTARG}
      ;;
    h)
      usage
      exit 0
      ;;
    ?)
      echo "Invalid option: -${opt}."
      usage 
      exit 1
      ;;
  esac
done

if [ -n "$PATTERN" ]; then FP="--filter-pattern $PATTERN" ; fi
if [ "$MODE" = "search" -o "$MODE" = 's' ] ; then
  if [[ "$REF_TIME" =~ [^0-9] ]]; then
    REF_EPOCH=$[$(date -d "$REF_TIME" +%s) * 1000] 
  else 
    REF_EPOCH=$REF_TIME
  fi
  set -x
  aws --region $REGION logs filter-log-events \
    --log-group-name $LOG_GROUP $FP \
    --start-time $[$REF_EPOCH - $[$MINS_BEFORE * 60 * 1000]] \
    --end-time $[$REF_EPOCH + $[$MINS_AFTER * 60 * 1000]] \
    --output json \
    | jq '.events | map(.message=(try .message|fromjson)) | del(.[].message | select(.url == "/api/health") | select(.res.statusCode == 200)) | del(.[].message | select(.url == "/api/health" or .url == "/api/job/health") | select(.res.statusCode == 200))' \
    | jq  -C | less -RX

elif [ "$MODE" = 'tail' -o "$MODE" = 't' ] ; then
  set -x
  aws --region $REGION logs tail --follow $LOG_GROUP $FP  --format json 

else
  echo "ERROR: Unknown mode '$MODE'" >&2
  exit 2 
fi