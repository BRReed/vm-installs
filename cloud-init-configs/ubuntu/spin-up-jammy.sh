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

