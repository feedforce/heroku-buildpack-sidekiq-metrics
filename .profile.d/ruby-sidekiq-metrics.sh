#!/bin/bash -eu

# For development
# $ REDIS_URL=redis://localhost:6379 DYNO=web.1 \
# > /path/to/.profile.d/ruby-sidekiq-metrics.sh /path/to/sidekiq-metrics

SIDEKIQ_METRICS=${1:-/app/bin/sidekiq-metrics}

SIDEKIQ_METRICS_DYNO=${SIDEKIQ_METRICS_DYNO:-web.1}
SIDEKIQ_METRICS_INTERVAL=${SIDEKIQ_METRICS_INTERVAL:-30}
SIDEKIQ_METRICS_TYPE=${SIDEKIQ_METRICS_TYPE:-sample}

setup_metrics() {
  # Collect sidekiq metrics on only one Dyno
  if [ -z "$REDIS_URL" ] || [ "$DYNO" != "$SIDEKIQ_METRICS_DYNO" ]; then
    return 0
  fi

  if [ ! -x "$SIDEKIQ_METRICS" ]; then
    echo "No sidekiq-metrics executable found. Not starting."
    return 1
  fi

  echo "sidekiq-metrics start..."
  (while true; do
     "$SIDEKIQ_METRICS" "$SIDEKIQ_METRICS_TYPE"
     sleep "$SIDEKIQ_METRICS_INTERVAL"
   done) &
}

setup_metrics
