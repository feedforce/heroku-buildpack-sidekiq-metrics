#!/bin/bash -eu

# echo "PATH -> $PATH"
# type bundle || true
# 
# PATH=/app/bin:"$PATH"
# 
# echo "PATH -> $PATH"
# type bundle || true
# 
# echo 'env ->'
# env

SIDEKIQ_METRICS=${1:-/app/bin/sidekiq-metrics}

setup_metrics() {
  # Collect sidekiq metrics only one Dyno
  if [ -z "$REDIS_URL" ] || [ "$DYNO" != web.1 ]; then
    return 0
  fi

  if [ ! -x "$SIDEKIQ_METRICS" ]; then
    echo "No sidekiq-metrics executable found. Not starting."
    return 1
  fi

  echo "sidekiq-metrics start..."
  (while true; do
     "$SIDEKIQ_METRICS"
     sleep 10
   done) &
}

setup_metrics
