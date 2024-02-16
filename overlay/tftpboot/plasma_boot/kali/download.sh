#!/bin/sh
echo "Downloading kali ..."
URL="http://kali.download/kali/dists/"

ARCH="amd64 i386"
DIST="kali-rolling kali-last-snapshot kali-dev"

mkdir -p /tmp/kali

echo "" > ./kali/menu.cfg
for a in $ARCH; do
	mkdir -p "./kali/$a"
	echo "menu begin $a" >> ./kali/menu.cfg
        for d in $DIST; do
		u="$URL/$d/main/installer-$a/current/images/netboot/netboot.tar.gz"
		wget -q "$u" -O /tmp/kali/netboot.tar.gz
		if [ -e /tmp/kali/netboot.tar.gz ]; then
			echo -e "\tmenu begin $d\n\t\tinclude plasma_boot/kali/${d}_${a}.cfg\n\tmenu end" >> ./kali/menu.cfg
			mkdir -p "./kali/$a/$d"
			mkdir -p /tmp/kali/extracted
			tar -C /tmp/kali/extracted -xvvzf /tmp/kali/netboot.tar.gz
			cp "/tmp/kali/extracted/kali-installer/$a/linux" "./kali/$a/$d/linux"
			cp "/tmp/kali/extracted/kali-installer/$a/initrd.gz" "./kali/$a/$d/initrd.gz"
			chmod a+r "./kali/$a/$d/linux" "./kali/$a/$d/initrd.gz"

			cp ./kali/template.cfg "./kali/${d}_${a}.cfg"
			sed -i 's/@@arch@@/'"$a"'/g;s/@@dist@@/'"$d"'/g;' "./kali/${d}_${a}.cfg"
			rm -rf /tmp/kali/extracted
			rm /tmp/kali/netboot.tar.gz
		fi
        done
	echo "menu end" >> ./kali/menu.cfg
done

rm -rf /tmp/kali

echo "Done."
