#!/bin/sh

# key is private info, value is replace_s
declare -A priv_map
# key is replace_s, value is private info
declare -A map_priv

conf_dir="/home/xun/.config/xray/my_xray/"
back_dir="${conf_dir}backup/"
private="${conf_dir}private"
routing="${conf_dir}03_routing.json"

file=(00_log 01_api 02_dns 03_routing 04_policy 05_inbounds 06_outbounds 07_transport 08_stats 09_reverse)
declare -A conf_file
declare -A back_file
declare -A xray_file
for BASE in ${file[@]}; do
    [[ -f ${conf_dir}${BASE}.json ]] || touch ${conf_dir}${BASE}.json
    [[ -f ${back_dir}${BASE}.json ]] || touch ${back_dir}${BASE}.json
    [[ -f /etc/xray/${BASE}.json ]] || touch /etc/xray/${BASE}.json
    [[ -f ${conf_dir}${BASE}.json ]] || echo '{}' > ${conf_dir}${BASE}.json
    [[ -f ${back_dir}${BASE}.json ]] || echo '{}' > ${back_dir}${BASE}.json
    [[ -f /etc/xray/${BASE}.json ]] || echo '{}' > /etc/xray/${BASE}.json
done
for BASE in ${file[@]}; do
  conf_file[$BASE]="${conf_dir}${BASE}.json"
  back_file[$BASE]="${back_dir}${BASE}.json"
  xray_file[$BASE]="/etc/xray/${BASE}.json"
done

# backup file
backup() {
  for BASE in ${file[@]}; do
    # if backup file not exist, create it
    if [ ! -e ${back_file[$BASE]} ]; then
      echo '{}' > ${back_file[$BASE]}
    fi
    /bin/cp ${xray_file[$BASE]} "/home/xun/.config/xray/my_xray/backup/"
  done
}

# read private info
read_info() {
  while read line; do
    priv_info=$(echo $line | awk -F: '{print $1}')
    replace_s=$(echo $line | awk -F: '{print $2}')
    priv_map[$priv_info]=$replace_s
    map_priv[$replace_s]=$priv_info
  done < ${private}
}

# replace private info
replace_info() {
  for BASE in ${file[@]}; do
    for key in ${!priv_map[@]}; do
      sed -i "s/$key/${priv_map[$key]}/g" ${conf_file[$BASE]}
      sed -i "s/$key/${priv_map[$key]}/g" ${back_file[$BASE]}
    done
  done
}

info_replace() {
  for BASE in ${file[@]}; do
    for key in ${!map_priv[@]}; do
      sed -i "s/$key/${map_priv[$key]}/g" ${conf_file[$BASE]}
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
  sed -i "s/proxy-tag/xun-proxy-jp/g" ${conf_dir}03_routing.json
  for BASE in ${file[@]}; do 
    # if file not exist, create it
    if [ ! -e ${xray_file[$BASE]} ]; then
      echo 'file not exist, create it'
      echo '{}' > ${xray_file[$BASE]}
    fi
    cat ${conf_file[$BASE]} > ${xray_file[$BASE]}
    echo "${conf_file[$BASE]} to ${xray_file[$BASE]}"
  done
  sed -i "s/xun-proxy-jp/proxy-tag/g" ${conf_dir}03_routing.json
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
        backup
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

parse_args "$@"
