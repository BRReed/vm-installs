#!/bin/sh


if (find user-data) then
  echo "user-data exists"
else
  echo "Creating user-data"
  tee "./user-data" > /dev/null << EOF
#cloud-config

users:
  - default
  - name: brian
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/sh
    ssh-authorized-keys:
      - $(cat ~/.ssh/id_ed25519.pub)
EOF
fi

if (find meta-data) then
  echo "meta-data exists"
else
  echo "Creating meta-data"
  touch meta-data
fi

if (find my-seed.img) then
  echo "my-seed.img exists"
else
  echo "Creating my-seed.img"
  touch my-seed.img
fi

if (find "openbsd-7.3-2023-04-22.qcow2") then
  echo "openbsd-7.3-2023-04-22.qcow2 exists"
else
  echo "Downloading OpenBSD V.7.3"
  wget "https://object-storage.public.mtl1.vexxhost.net/swift/v1/1dbafeefbd4f4c80864414a441e72dd2/bsd-cloud-image.org/images/openbsd/7.3/2023-04-22/ufs/openbsd-7.3-2023-04-22.qcow2"
fi

if [ -s my-seed.img ]; then
  echo "my-seed.img has been supplied with data"
else
  echo "Supplying my-seed.img with data"
  cloud-localds my-seed.img user-data meta-data
fi

if [ -f ./openbsd-73-vm.qcow2 ]; then
  echo "openbsd-73-vm.qcow2 already exists"
else
  echo "creating openbsd-73-vm.qcow2"
  qemu-img create -F qcow2 -b "openbsd-7.3-2023-04-22.qcow2" -f qcow2 ./openbsd-73-vm.qcow2 50G
fi

if (virsh list | grep running | grep openbsd-cloud) then
  echo "openbsd 7.3 vm already exists"
else
  echo "Installing openbsd 7.3 vm"
  virt-install --name openbsd-cloud --memory 4096 --vcpus 4 --os-variant "openbsd7.2" --disk ./openbsd-73-vm.qcow2 --disk ./my-seed.img --import
fi
