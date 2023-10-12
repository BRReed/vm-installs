#!/bin/sh

USER="$1"
VMNAME="$2"

ssh -t -o StrictHostKeyChecking=no $USER@$(virsh domifaddr $VMNAME | \
                                           awk -F'[ /]+' '{if (NR>2) print $5}')