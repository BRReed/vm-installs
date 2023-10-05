#!/bash/sh


if !(virsh list --all | grep " openbsd-cloud ") then
  echo "openbsd-cloud vm does not exist"
else
  echo "destroy, undefine and removing all storage for openbsd-cloud vm"
  virsh destroy openbsd-cloud && virsh undefine openbsd-cloud --remove-all-storage
fi

if !(find "openbsd-7.3-2023-04-22.qcow2") then
  echo "openbsd-7.3-2023-04-22.qcow2 does not exist"
else
  echo "removing openbsd-7.3-2023-04-22.qcow2"
  rm -f "openbsd-7.3-2023-04-22.qcow2" 
fi

if !(find user-data) then
  echo "user-data does not exist"
else
  echo "removing user-data"
  rm user-data
fi

if !(find meta-data) then
  echo "meta-data does not exist"
else
  echo "removing meta-data"
  rm meta-data
fi
