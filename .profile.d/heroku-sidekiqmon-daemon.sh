#!/bin/sh -eu

SIDEKIQMON=${1:-/app/vendor/bundle/bin/sidekiqmon}

if [ ! -x "$SIDEKIQMON" ]; then
  echo "No sidekiqmon executable found. Not starting."
  exit 1
fi

sidekiqmond() {
  while true; do
    "$SIDEKIQMON"
    sleep 10
  done
}

sidekiqmond &
