#!/bin/sh

# arg $1=username; arg $2=vm name
ssh -t -o StrictHostKeyChecking=no $1@$(virsh domifaddr $2 | awk -F'[ /]+' '{if (NR>2) print $5}')