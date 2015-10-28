#!/bin/bash

check_required_args() {
  if [[ -z "${BUILDKITE_COMMAND:-}" ]]; then
    echo "No command to run. Did you provide a 'command' for this step?"
    exit 1
  fi
} && check_required_args

compose_force_cleanup() {
  echo "~~~ Cleaning up Docker containers"

  run_docker_compose "kill" || true
  run_docker_compose "rm --force -v" || true

  # The adhoc run container isn't cleaned up by compose, so we have to do it ourselves
  buildkite-run "docker rm -f -v $(docker_compose_project_name)_${BUILDKITE_PLUGIN_DOCKER_COMPOSE_RUN}_run_1" || true
} && trap compose_force_cleanup EXIT

echo "~~~ Running command in Docker Compose service: $BUILDKITE_PLUGIN_DOCKER_COMPOSE_RUN"

echo "TODO"

exit 1

run_docker_compose "run $BUILDKITE_PLUGIN_DOCKER_COMPOSE_RUN \"$BUILDKITE_COMMAND\""