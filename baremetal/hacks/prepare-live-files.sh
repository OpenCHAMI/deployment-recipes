ssh -t admin '
mkdir -p mountpoint
mount 2>/dev/null -o loop file.iso mountpoint
cp ~/mountpoint/arch/boot/x86_64/vmlinuz-linux ~/disk-images
cp ~/mountpoint/arch/boot/x86_64/initramfs-linux.img ~/disk-images
mkdir -p ~/disk-images/arch/x86_64
cp ~/mountpoint/arch/x86_64/airootfs.sfs ~/disk-images/arch/x86_64
cp ~/mountpoint/arch/x86_64/airootfs.sfs.cms.sig ~/disk-images/arch/x86_64
'
