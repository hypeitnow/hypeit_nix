#!/bin/bash

sudo dosfslabel /dev/vda1 "BOOT"
sudo e2label /dev/vda2 "ROOT"

echo -e "Checking labels..."
sudo blkid 