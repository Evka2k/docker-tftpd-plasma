#!/bin/sh
URL="http://ubuntu.mirror.vu.lt/ubuntu/dists"
NAME="ubuntu"
ARCH="amd64 i386"
DIST="devel noble mantic lunar jammy focal bionic trusty xenial"

echo "Downloading $NAME ..."

mkdir -p "/tmp/$NAME"
echo "" > "./$NAME/menu.cfg"
echo "" > "./$NAME/grub.cfg"
for a in $ARCH; do
	mkdir -p "./$NAME/$a"
	echo "menu begin $a" >> "./$NAME/menu.cfg"
	echo -e "menuentry '$a' {\n\tconfigfile plasma_boot/$NAME/grub_${a}.cfg\n}" >> "./$NAME/grub.cfg"
	echo "" > "./$NAME/grub_${a}.cfg"
        for d in $DIST; do
		u="$URL/$d/main/installer-$a/current/images/netboot/netboot.tar.gz"
		wget -q "$u" -O /tmp/$NAME/netboot.tar.gz
		if [ -e /tmp/$NAME/netboot.tar.gz ]; then
			echo -e "\tmenu begin $d\n\t\tinclude plasma_boot/$NAME/${d}_${a}.cfg\n\tmenu end" >> "./$NAME/menu.cfg"
			echo -e "menuentry '$d' {\n\tconfigfile plasma_boot/$NAME/grub_${d}_${a}.cfg\n}" >> "./$NAME/grub_${a}.cfg"
			mkdir -p "./$NAME/$a/$d"
			mkdir -p "/tmp/$NAME/extracted"
			tar -C "/tmp/$NAME/extracted" -xvvzf "/tmp/$NAME/netboot.tar.gz"
			cp "/tmp/$NAME/extracted/$NAME-installer/$a/linux" "./$NAME/$a/$d/linux"
			cp "/tmp/$NAME/extracted/$NAME-installer/$a/initrd.gz" "./$NAME/$a/$d/initrd.gz"
			chmod a+r "./$NAME/$a/$d/linux" "./$NAME/$a/$d/initrd.gz"

			cp "./$NAME/template.cfg" "./$NAME/${d}_${a}.cfg"
			sed -i 's/@@arch@@/'"$a"'/g;s/@@dist@@/'"$d"'/g;' "./$NAME/${d}_${a}.cfg"

			cp "./$NAME/grub_template.cfg" "./$NAME/grub_${d}_${a}.cfg"
			sed -i 's/@@arch@@/'"$a"'/g;s/@@dist@@/'"$d"'/g;' "./$NAME/grub_${d}_${a}.cfg"

			rm -rf "/tmp/$NAME/extracted"
			rm "/tmp/$NAME/netboot.tar.gz"
		fi
        done
	echo "menu end" >> "./$NAME/menu.cfg"
done

rm -rf "/tmp/$NAME"

echo "Done."
