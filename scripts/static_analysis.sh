#!/bin/bash

WHITELIST_CONTENT="^// DO NOT EDIT|^// File generated by|^// Automatically generated|^// Code generated by protoc-gen-gogo. DO NOT EDIT."
WHITELIST_ERRORS="should not use dot imports"

function static_analysis() {
  local TOOL="${@}"
  local PWD=$(pwd)

  local FILES=$(find "${PWD}" -mount -name "*.go" -type f -not -path "${PWD}/vendor/*" -exec grep -LE "${WHITELIST_CONTENT}"  {} +)

  local CMD=$(${TOOL} "${PWD}/cmd${SELECTOR}")
  local CORE=$(${TOOL} "${PWD}/core${SELECTOR}")
  local DB=$(${TOOL} "${PWD}/db${SELECTOR}")
  local HTTP=$(${TOOL} "${PWD}/http${SELECTOR}")
  local IDXMAP=$(${TOOL} "${PWD}/idxmap${SELECTOR}")
  local LOGGING=$(${TOOL} "${PWD}/logging${SELECTOR}")
  local MESSAGING=$(${TOOL} "${PWD}/messaging${SELECTOR}")
  local SERVICELABEL=$(${TOOL} "${PWD}/servicelabel${SELECTOR}")
  local UTILS=$(${TOOL} "${PWD}/utils${SELECTOR}")

  local ALL="$CMD
$CORE
$DB
$HTTP
$IDXMAP
$LOGGING
$MESSAGING
$SERVICELABEL
$UTILS
"

  local OUT=$(echo "${ALL}" | grep -F "${FILES}" | grep -v "${WHITELIST_ERRORS}")
  if [[ ! -z $OUT ]] ; then
    echo "${OUT}" 1>&2
    exit 1
  fi
}
