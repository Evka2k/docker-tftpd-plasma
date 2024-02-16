#!/bin/sh
echo "Downloading debian ..."
URL="http://debian.mirror.vu.lt/debian/dists"

ARCH="amd64 i386"
DIST="stable oldstable sid bookworm bullseye buster trixie testing unstable"

mkdir -p /tmp/debian

echo "" > ./debian/menu.cfg
for a in $ARCH; do
	mkdir -p "./debian/$a"
	echo "menu begin $a" >> ./debian/menu.cfg
        for d in $DIST; do
		u="$URL/$d/main/installer-$a/current/images/netboot/netboot.tar.gz"
		wget -q "$u" -O /tmp/debian/netboot.tar.gz
		if [ -e /tmp/debian/netboot.tar.gz ]; then
			echo -e "\tmenu begin $d\n\t\tinclude plasma_boot/debian/${d}_${a}.cfg\n\tmenu end" >> ./debian/menu.cfg
			mkdir -p "./debian/$a/$d"
			mkdir -p /tmp/debian/extracted
			tar -C /tmp/debian/extracted -xvvzf /tmp/debian/netboot.tar.gz
			cp "/tmp/debian/extracted/debian-installer/$a/linux" "./debian/$a/$d/linux"
			cp "/tmp/debian/extracted/debian-installer/$a/initrd.gz" "./debian/$a/$d/initrd.gz"
			chmod a+r "./debian/$a/$d/linux" "./debian/$a/$d/initrd.gz"

			cp ./debian/template.cfg "./debian/${d}_${a}.cfg"
			sed -i 's/@@arch@@/'"$a"'/g;s/@@dist@@/'"$d"'/g;' "./debian/${d}_${a}.cfg"
			rm -rf /tmp/debian/extracted
			rm /tmp/debian/netboot.tar.gz
		fi
        done
	echo "menu end" >> ./debian/menu.cfg
done

rm -rf /tmp/debian

echo "Done."
