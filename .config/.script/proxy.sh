#!/bin/sh

# 设置需要使用代理的协议
proxy_protocol="socks5"
proxy_port="10808"
# 设置代理服务器的地址和端口号
proxy_server="$proxy_protocol://127.0.0.1:$proxy_port"

# 设置不需要使用代理的主机或域名
no_proxy="localhost,127.0.0.1,.local"

default_proxy_enabled="true"

# 设置代理环境变量
set_proxy() {
	export http_proxy="$proxy_server"
	export https_proxy="$proxy_server"
	export ftp_proxy="$proxy_server"
	export rsync_proxy="$proxy_server"
	export all_proxy="$proxy_server"
	export HTTP_PROXY="$proxy_server"
	export HTTPS_PROXY="$proxy_server"
	export FTP_PROXY="$proxy_server"
	export RSYNC_PROXY="$proxy_server"
	export ALL_PROXY="$proxy_server"

	# 设置不需要使用代理的主机或域名
	export no_proxy="$no_proxy"
	export NO_PROXY="$no_proxy"

	echo "代理已开启，代理服务器地址：$http_proxy"
}
# 取消代理
unset_proxy() {
	unset http_proxy
	unset https_proxy
	unset ftp_proxy
	unset rsync_proxy
	unset all_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
	unset FTP_PROXY
	unset RSYNC_PROXY
	unset ALL_PROXY

	unset no_proxy
	unset NO_PROXY

	echo "代理已关闭"
}

while case $1 in
	-p)
		shift
		proxy_protocol="$1"
		shift
		echo $proxy_protocol
		if [ "$proxy_protocol" = "http" ]; then
			proxy_point="10809"
			proxy_server="$proxy_protocol://127.0.0.1:$proxy_point"
		fi
		set_proxy
		;;
	-e)
		shift
		unset_proxy
		;;
	*)
		break
		;;
	esac do true; done

if [ "$#" -eq 0 ] || [ -z "$1" ]; then
	set_proxy
fi
