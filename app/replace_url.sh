#!/usr/bin/env bash

function replace_url() {
  wp search-replace --all-tables --report-changed-only "${LIVE_URL}" "${LOCAL_URL}"
  wp search-replace --all-tables --report-changed-only "https://${LOCAL_URL}" "http://${LOCAL_URL}"
}
