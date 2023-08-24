#!/bin/sh

# Tproxy settings
tproxy() {
  whoami=$(whoami)
  if [ "$whoami" != "root" ]; then
    echo "please run as root"
    exit 1
  fi
  if [ "$1" == "start" ]; then
  	systemctl restart nftables.service
  elif [ "$1" == "stop" ]; then
  	nft flush ruleset
  fi
}

parse_args() {
  if [ $# -eq 0 ]; then
    tproxy "start"
    exit 1
  fi
  while [ $# -gt 0 ]; do
    key="$1"

    case $key in
      -e)
				tproxy "stop"
				shift
				;;
      -s)
				tproxy "start"
				shift
				;;
			-h|--help)
				help
				shift
				;;
      *)
        help
        exit 1
        ;;
    esac
  done
}

# main
parse_args "$@"
