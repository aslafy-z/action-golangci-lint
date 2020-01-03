#!/bin/sh

cd "${GITHUB_WORKSPACE}/${INPUT_DIRECTORY}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

INPUT_REVIEWDOG_FLAGS=$INPUT_REVIEWDOG_FLAGS
if [ -n "$INPUT_DIRECTORY" ]; then
  set -x
  path=$INPUT_DIRECTORY
  path=$(echo "$path" | sed 's/^\/\(.*\)\/$/\1/g')
  count=$(echo "$path" | awk -F"/" '{print NF-1}')
  [ -n "$path" ] && [ "$count" = "0" ] && count=1
  [ "$count" != "0" ] && count=$(("$count" + 1))
  INPUT_REVIEWDOG_FLAGS=${INPUT_REVIEWDOG_FLAGS:--strip $count}
fi

# shellcheck disable=SC2086
golangci-lint run --out-format line-number ${INPUT_GOLANGCI_LINT_FLAGS} \
  | reviewdog -f=golangci-lint -name="${INPUT_TOOL_NAME}" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}" ${INPUT_REVIEWDOG_FLAGS}
