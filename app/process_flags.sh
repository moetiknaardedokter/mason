#!/usr/bin/env bash

function process_flags() {
  while test $# -gt 0; do
    case "$1" in
    -h | --help)
      display_help_mssg
      exit 0
      ;;
    --uploads)
      ARG_SYNC_UPLOADS=1
      shift
      ;;
    --db-only)
      ARG_SYNC_DB=1
      shift
      ;;
    --files-only)
      ARG_SYNC_FILES=1
      shift
      ;;
    *)
      echo -e "${C_RED}ERROR:${C_OFF} Unknow argument: ${C_ORN}${1}${C_OFF}"

      display_help_mssg

      exit
      break
      ;;
    esac
  done

  print_version

  if [[ ${ARG_SYNC_DB} == 1 ]] && [[ ${ARG_SYNC_FILES} == 9 ]]; then
    echo -ne "Syncing the ${C_ORN}database${C_OFF} only"
    ARG_SYNC_FILES=0
  elif [[ ${ARG_SYNC_DB} == 9 ]] && [[ ${ARG_SYNC_FILES} == 1 ]]; then
    echo -ne "Syncing the ${C_ORN}files${C_OFF} only"
    ARG_SYNC_DB=0
  else
    echo -ne "Syncing both ${C_ORN}files${C_OFF} and ${C_ORN}db${C_OFF}"
    ARG_SYNC_DB=1
    ARG_SYNC_FILES=1
  fi

  if [[ ${ARG_SYNC_UPLOADS} == 1 ]]; then
    echo -e ", also sync ${C_ORN}uploads${C_OFF} folder."
  else
    echo -e ", don't sync ${C_ORN}uploads${C_OFF} folder."
  fi
}
