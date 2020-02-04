#!/bin/bash -eu

# For development
# $ REDIS_URL=redis://localhost:6379 DYNO=web.1 \
# > /path/to/.profile.d/ruby-sidekiq-metrics.sh /path/to/sidekiq-metrics

SIDEKIQ_METRICS=${1:-/app/bin/sidekiq-metrics}

SIDEKIQ_METRICS_DYNO=${SIDEKIQ_METRICS_DYNO:-web.1}
SIDEKIQ_METRICS_SLEEP_SEC=${SIDEKIQ_METRICS_SLEEP_SEC:-30}

setup_metrics() {
  # Collect sidekiq metrics only one Dyno
  if [ -z "$REDIS_URL" ] || [ "$DYNO" != "$SIDEKIQ_METRICS_DYNO" ]; then
    return 0
  fi

  if [ ! -x "$SIDEKIQ_METRICS" ]; then
    echo "No sidekiq-metrics executable found. Not starting."
    return 1
  fi

  echo "sidekiq-metrics start..."
  (while true; do
     "$SIDEKIQ_METRICS"
     sleep "$SIDEKIQ_METRICS_SLEEP_SEC"
   done) &
}

setup_metrics
