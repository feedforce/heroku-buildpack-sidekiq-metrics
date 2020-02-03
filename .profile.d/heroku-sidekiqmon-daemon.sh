#!/bin/bash -eu

echo "PATH -> $PATH"
type bundle || true

SIDEKIQMON=${1:-/app/vendor/bundle/bin/sidekiqmon}

setup_metrics() {
  # don't do anything if we don't have a metrics url.
  if [[ -z "$REDIS_URL" ]] || [[ "${DYNO}" = run\.* ]]; then
    return 0
  fi

  if [ ! -x "$SIDEKIQMON" ]; then
    echo "No sidekiqmon executable found. Not starting."
    return 1
  fi

  (while true; do
     "$SIDEKIQMON"
     sleep 10
   done) &
}

setup_metrics
