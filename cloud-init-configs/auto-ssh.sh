#!/bin/sh

USER="$1"
VM_NAME="$2"

ip_addr=$(virsh domifaddr "$VM_NAME" | \
          grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
          awk '{print $1}'\
        )

echo "$VM_NAME : $ip_addr"

ssh "$USER"@"$ip_addr"