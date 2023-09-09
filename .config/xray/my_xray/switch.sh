#!/bin/sh

declare -A nodes

list() {
  node=$(grep '_uuid' private | wc -l)
  for i in $(seq 1 1 $node); do
    # list all nodes
    #set -x
    lnico=$(grep '_uuid' private | awk -F: '{print $2}' | awk -F_ '{print $1}' | sed -n "$i"p)
    larea=$(grep '_uuid' private | awk -F: '{print $2}' | awk -F_ '{print $2}' | sed -n "$i"p)
    echo "$i:${lnico}-proxy-${larea}"
    tmp="${lnico}-proxy-${larea}"
    nodes[$i]=$tmp
    sed -i "s/${tmp}/proxy-tag/g" 03_routing.json
  done
}

switch() {
  list
  # switch node
  echo "Please input the number of node:"
  read num
  if [ $num -gt 0 ]; then
    nico=$(grep '_uuid' private | awk -F: '{print $2}' | awk -F_ '{print $1}' | sed -n "$num"p)
    area=$(grep '_uuid' private | awk -F: '{print $2}' | awk -F_ '{print $2}' | sed -n "$num"p)
    nodeN="${nico}-proxy-${area}"
    sed -i "s/proxy-tag/${nodeN}/g" 03_routing.json
    echo "Switch to node $num"
  else
    echo "Please input the right number"
  fi
}

end() {
  for node in ${nodes[@]}; do
    #set -x
    sed -i "s/${node}/proxy-tag/g" 03_routing.json
  done
}

n_node=$(awk -F':' '/\-proxy-/ {print $2; exit}' /etc/xray/03_routing.json | awk '{print $1}')
echo "Current node is ${n_node}"
switch
sudo ./sync.sh -s
sudo systemctl restart xray.service
end

