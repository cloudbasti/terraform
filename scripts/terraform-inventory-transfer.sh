#!/bin/bash

KEY_PATH=$1
INVENTORY_PATH=$2
COMMANDER_IP=$3

chmod 600 "$KEY_PATH"

scp -o StrictHostKeyChecking=no -i "$KEY_PATH" "$INVENTORY_PATH" "ubuntu@$COMMANDER_IP:~/inventory.yml"