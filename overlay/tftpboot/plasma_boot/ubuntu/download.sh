#!/bin/sh
echo "Downloading ubuntu ..."
URL="http://ubuntu.mirror.vu.lt/ubuntu/dists"

ARCH="amd64 i386"
DIST="devel noble mantic lunar jammy focal bionic trusty xenial"

mkdir -p /tmp/ubuntu

echo "" > ./ubuntu/menu.cfg
for a in $ARCH; do
	mkdir -p "./ubuntu/$a"
	echo "menu begin $a" >> ./ubuntu/menu.cfg
        for d in $DIST; do
		u="$URL/$d/main/installer-$a/current/images/netboot/netboot.tar.gz"
		wget -q "$u" -O /tmp/ubuntu/netboot.tar.gz
		if [ -e /tmp/ubuntu/netboot.tar.gz ]; then
			echo -e "\tmenu begin $d\n\t\tinclude plasma_boot/ubuntu/${d}_${a}.cfg\n\tmenu end" >> ./ubuntu/menu.cfg
			mkdir -p "./ubuntu/$a/$d"
			mkdir -p /tmp/ubuntu/extracted
			tar -C /tmp/ubuntu/extracted -xvvzf /tmp/ubuntu/netboot.tar.gz
			cp "/tmp/ubuntu/extracted/ubuntu-installer/$a/linux" "./ubuntu/$a/$d/linux"
			cp "/tmp/ubuntu/extracted/ubuntu-installer/$a/initrd.gz" "./ubuntu/$a/$d/initrd.gz"
			chmod a+r "./ubuntu/$a/$d/linux" "./ubuntu/$a/$d/initrd.gz"

			cp ./ubuntu/template.cfg "./ubuntu/${d}_${a}.cfg"
			sed -i 's/@@arch@@/'"$a"'/g;s/@@dist@@/'"$d"'/g;' "./ubuntu/${d}_${a}.cfg"
			rm -rf /tmp/ubuntu/extracted
			rm /tmp/ubuntu/netboot.tar.gz
		fi
        done
	echo "menu end" >> ./ubuntu/menu.cfg
done

rm -rf /tmp/ubuntu

echo "Done."
