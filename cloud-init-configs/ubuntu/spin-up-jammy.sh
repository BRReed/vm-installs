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

if (find jammy-server-cloudimg-amd64.img) then
  echo "jammy-server-cloudimg-amd64.img exists"
else
  echo "Downloading latest jammy-server-cloudimg-amd64.img"
  wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
fi

if [ -s my-seed.img ]; then
  echo "my-seed.img has been supplied with data"
else
  echo "Supplying my-seed.img with data"
  cloud-localds my-seed.img user-data meta-data
fi

if [ -f ./ub-jammy-vm.qcow2 ]; then
  echo "ub-jammy-vm.qcow2 already exists"
else
  echo "creating ub-jammy-vm.qcow2"
  qemu-img create -F qcow2 -b jammy-server-cloudimg-amd64.img -f qcow2 ./ub-jammy-vm.qcow2 50G
fi

if (virsh list | grep running | grep jammy-cloud) then
  echo "jammy-cloud vm already exists"
else
  echo "Installing jammy-cloud vm"
  virt-install --name jammy-cloud --memory 4096 --vcpus 4 --os-variant ubuntujammy --disk ./ub-jammy-vm.qcow2 --disk ./my-seed.img --import
fi