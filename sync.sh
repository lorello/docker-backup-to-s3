#!/bin/bash

set -e

echo "Job started: $(date)"

[[ -n $HEALTHCHECK_ID ]] && curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/${HEALTHCHECK_ID}/start

/usr/local/bin/s3cmd sync $PARAMS "$DATA_PATH" "$S3_PATH"

if [[ $? -eq 0 ]]; then
  [[ -n $HEALTHCHECK_ID ]] && curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/${HEALTHCHECK_ID}
else
  [[ -n $HEALTHCHECK_ID ]] && curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/${HEALTHCHECK_ID}/fail
fi

echo "Job finished: $(date)"
