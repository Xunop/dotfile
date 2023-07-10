#!/bin/sh

# 设置需要使用代理的协议
proxy_protocol="http"
proxy_port="10808"
proxy_server="$proxy_protocol://127.0.0.1:$proxy_port"

# 设置不需要使用代理的主机或域名
no_proxy="localhost,127.0.0.1,.local"

default_proxy_enabled="true"

# 设置代理环境变量
set_proxy() {
	proxy_server="$proxy_protocol://127.0.0.1:$proxy_port"
	export http_proxy="$proxy_server"
	export https_proxy="$proxy_server"
	#export ftp_proxy="$proxy_server"
	#export rsync_proxy="$proxy_server"
	export all_proxy="$proxy_server"
	export HTTP_PROXY="$proxy_server"
	export HTTPS_PROXY="$proxy_server"
	#export FTP_PROXY="$proxy_server"
	#export RSYNC_PROXY="$proxy_server"
	export ALL_PROXY="$proxy_server"

	# 设置不需要使用代理的主机或域名
	export no_proxy="$no_proxy"
	export NO_PROXY="$no_proxy"

	echo "proxy start."
	echo "proxy server: $proxy_server"
}

# 取消代理
unset_proxy() {
	unset http_proxy
	unset https_proxy
	#unset ftp_proxy
	#unset rsync_proxy
	unset all_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
	#unset FTP_PROXY
	#unset RSYNC_PROXY
	unset ALL_PROXY

	unset no_proxy
	unset NO_PROXY

	echo "proxy stop."
}

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
    echo "default settings:"
    echo "  proxy server: $proxy_server"
    set_proxy
  fi
  while [ $# -gt 0 ]; do
    key="$1"

    case $key in
      -p|--protocol)
        proxy_protocol="$2"
        set_proxy
        shift 2
        ;;
      -e|--exit)
        unset_proxy
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

help() {
  echo "usage: source xproxy [options]"
  echo "options:"
  echo "  -p, --protocol <protocol>  set proxy protocol"
  echo "  -e, --exit                 unset proxy"
  echo "  -h, --help                 show help"
  echo "example:"
  echo "  source xproxy -p http"
  echo "  source xproxy -p socks5"
  echo "  source xproxy -e"
}

# main
parse_args "$@"
