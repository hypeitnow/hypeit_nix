
sudo dosfslabel /dev/sda1 "BOOT"
sudo e2label /dev/sda2 "ROOT"

echo -e "Checking labels..."
sudo blkid 