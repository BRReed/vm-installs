#!/bash/sh


if !(virsh list --all | grep " jammy-cloud ") then
  echo "jammy-cloud vm does not exist"
else
  echo "destroy, undefine and removing all storage for jammy-cloud vm"
  virsh destroy jammy-cloud && virsh undefine jammy-cloud --remove-all-storage
fi

if !(find jammy-server-cloudimg-amd64.img) then
  echo "jammy-server-cloudimg-amd64.img does not exist"
else
  echo "removing jammy-server-cloudimg-amd64.img"
  rm -f jammy-server-cloudimg-amd64.img 
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