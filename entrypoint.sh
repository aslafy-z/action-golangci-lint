#!/bin/sh

cd "${GITHUB_WORKSPACE}/${INPUT_DIRECTORY}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# shellcheck disable=SC2086
golangci-lint run --out-format line-number ${INPUT_GOLANGCI_LINT_FLAGS} \
  | sed  -r "s,(([[:alpha:]])?(\\\\ |[^  ])+?):([[:digit:]]+):(.+)$,${INPUT_DIRECTORY}\1:\4:\5,g" \
  | reviewdog -f=golangci-lint -name="${INPUT_TOOL_NAME}" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}" -diff "git diff"