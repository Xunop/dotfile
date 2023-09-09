#!/bin/sh

# key is private info, value is replace_s
declare -A priv_map
# key is replace_s, value is private info
declare -A map_priv

conf_file=(00_log 01_api 02_dns 03_routing 04_policy 05_inbounds 06_outbounds 07_transport 08_stats 09_reverse)

# backup file
backup() {
  for BASE in ${conf_file[@]}; do 
    # if file not exist, create it
    if [ ! -e "/home/xun/.config/xray/my_xray/backup/$BASE.json" ]; then
      echo '{}' > "/home/xun/.config/xray/my_xray/backup/$BASE.json"
    fi
    /bin/cp "/etc/xray/$BASE.json" "/home/xun/.config/xray/my_xray/backup/"
  done
}

# read private info
read_info() {
  while read line; do
    priv_info=$(echo $line | awk -F: '{print $1}')
    replace_s=$(echo $line | awk -F: '{print $2}')
    priv_map[$priv_info]=$replace_s
    map_priv[$replace_s]=$priv_info
  done < private
}

# replace private info
replace_info() {
  for BASE in ${conf_file[@]}; do 
    for key in ${!priv_map[@]}; do
      sed -i "s/$key/${priv_map[$key]}/g" "$BASE.json"
    done
  done
}

info_replace() {
  for BASE in ${conf_file[@]}; do 
    for key in ${!map_priv[@]}; do
      sed -i "s/$key/${map_priv[$key]}/g" "$BASE.json"
    done
  done
}

# sync to /etc/xray
sync_xray() {
  whoami=$(whoami)
  if [ "$whoami" != "root" ]; then
    echo "please run as root"
    exit 1
  fi
  
  echo "please make sure your xray run command is '/usr/bin/xray run -confdir /etc/xray"
  sed -i "s/proxy-tag/xun-proxy-jp/g" 03_routing.json
  for BASE in ${conf_file[@]}; do 
    # if file not exist, create it
    if [ ! -e "/etc/xray/$BASE.json" ]; then
      echo 'file not exist, create it'
      echo '{}' > "/etc/xray/$BASE.json"
    fi
    cat "$BASE.json" > "/etc/xray/$BASE.json"
  done
  sed -i "s/xun-proxy-jp/proxy-tag/g" 03_routing.json
  echo "done. but you need to restart xray.service"
  echo "sudo systemctl restart xray.service"
}


# help
help() {
  echo "Usage: $0 [option]"
  echo "Options:"
  echo "  -r, --replace    replace private info (replace the private information with the corresponding information in the private file)"
  echo "  -i, --info       info replace (replace private information into files)"
  echo "  -s, --sync       sync to /etc/xray"
  exit 1
}

parse_args() {
  if [ $# -eq 0 ]; then
    help
    exit 1
  fi
  while [ $# -gt 0 ]; do
    key="$1"

    case $key in
      -r|--replace)
        replace_info
        shift
        ;;
      -i|--info)
        info_replace
        shift
        ;;
      -s|--sync)
        info_replace
        sync_xray
        replace_info
        shift
        ;;
      -h|--help)
        help
        shift
        ;;
      *)
        echo "unknown option"
        exit 1
        ;;
    esac
  done
}

# main
read_info

backup

parse_args "$@"
