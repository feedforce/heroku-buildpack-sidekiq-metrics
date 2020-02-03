#!/bin/bash -eu

SIDEKIQMON=${1:-/app/vendor/bundle/bin/sidekiqmon}

if [ ! -x "$SIDEKIQMON" ]; then
  echo "No sidekiqmon executable found. Not starting."
  exit 1
fi

sidekiqmond() {
  # don't do anything if we don't have a metrics url.
  if [[ -z "$REDIS_URL" ]] || [[ "${DYNO}" = run\.* ]]; then
    return 0
  fi

  while true; do
    "$SIDEKIQMON"
    sleep 10
  done
}

sidekiqmond &
