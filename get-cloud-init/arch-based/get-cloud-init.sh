#!bin/bash

if ( which cloud-init )
then
  echo "-> cloud-init is installed"
else
  echo "-> installing cloud-init"
  pamac install cloud-init --no-confirm
fi