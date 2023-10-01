#!/bin/sh


if (find user-data) then
  echo "user-data exists"
else
  echo "Creating user-data"
  touch user-data
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

cat << EOF > user-data
#cloud-config

users:
  - default
  - name: brian
    sudo: ["ALL-(ALL) NOPASSWD:ALL"]
    shell: /bin/sh
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINbliisKG/Rajx1joDff9Q6Kh9tLL+KD9Zqe4ZOsVttU b.r.reed@gmail.com
EOF

cloud-localds my-seed.img user-data meta-data

qemu-img create -F qcow2 -b jammy-server-cloudimg-amd64.img -f qcow2 ./ub-jammy-vm.qcow2 50G
virt-install --name testvm3 --memory 4096 --vcpus 4 --os-variant ubuntujammy --disk ./ub-jammy-vm.qcow2 --disk ./my-seed.img --import
