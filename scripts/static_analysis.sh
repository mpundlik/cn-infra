#!/bin/bash

WHITELIST_CONTENT="^// DO NOT EDIT|^// File generated by|^// Automatically generated|^// Code generated by protoc-gen-go. DO NOT EDIT.|^// Code generated by protoc-gen-gogo. DO NOT EDIT."
WHITELIST_ERRORS="should not use dot imports"

function static_analysis() {
  local TOOL="${@}"
  local PWD=$(pwd)

  local FILES=$(find "${PWD}" -mount -name "*.go" -type f -not -path "${PWD}/vendor/*" -exec grep -LE "${WHITELIST_CONTENT}"  {} +)

  local CORE=$(${TOOL} "${PWD}/core${SELECTOR}")
  local DATASYNC=$(${TOOL} "${PWD}/datasync${SELECTOR}")
  local DB=$(${TOOL} "${PWD}/db${SELECTOR}")
  local EXAMPLES=$(${TOOL} "${PWD}/examples${SELECTOR}")
  local FLAVORS=$(${TOOL} "${PWD}/flavors${SELECTOR}")
  local HTTPMUX=$(${TOOL} "${PWD}/rpc/rest${SELECTOR}")
  local IDXMAP=$(${TOOL} "${PWD}/idxmap${SELECTOR}")
  local LOGGING=$(${TOOL} "${PWD}/logging${SELECTOR}")
  local MESSAGING=$(${TOOL} "${PWD}/messaging${SELECTOR}")
  local SERVICELABEL=$(${TOOL} "${PWD}/servicelabel${SELECTOR}")
  local PROBE=$(${TOOL} "${PWD}/health/probe${SELECTOR}")
  local STATUSCHECK=$(${TOOL} "${PWD}/health/statuscheck${SELECTOR}")
  local UTILS=$(${TOOL} "${PWD}/utils${SELECTOR}")

  local ALL="$CORE
$DATASYNC
$DB
$EXAMPLES
$FLAVORS
$HTTPMUX
$IDXMAP
$LOGGING
$MESSAGING
$SERVICELABEL
$PROBE
$STATUSCHECK
$UTILS
"

  local OUT=$(echo "${ALL}" | grep -F "${FILES}" | grep -v "${WHITELIST_ERRORS}")
  if [[ ! -z $OUT ]] ; then
    echo "${OUT}" 1>&2
    exit 1
  fi
}
