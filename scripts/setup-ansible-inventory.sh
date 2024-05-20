#!/bin/bash

if [ $# -eq 0 ]; then
  echo "No IP addresses provided. Usage: ./assign_ips.sh <IP1> <IP2> ... <IPn>"
  exit 1
fi

SCRIPT_DIR=$(dirname "$(realpath "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")
echo $PARENT_DIR

source $PARENT_DIR/ansible-venv/bin/activate
pip install -r $PARENT_DIR/kubespray/requirements.txt
cp -rfp $PARENT_DIR/kubespray/inventory/sample $PARENT_DIR/kubespray/inventory/mycluster

declare -a IPS=("$@")
CONFIG_FILE=$PARENT_DIR/kubespray/inventory/mycluster/hosts.yaml python3 $PARENT_DIR/kubespray/contrib/inventory_builder/inventory.py ${IPS[@]}
