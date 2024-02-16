#!/bin/sh
echo "Downloading memtest..."

mkdir -p /tmp/memtest
wget https://www.memtest.org/download/v7.00/mt86plus_7.00.binaries.zip -O /tmp/memtest/memtest.zip
unzip -d /tmp/memtest -x /tmp/memtest/memtest.zip
cp /tmp/memtest/memtest32.efi ./memtest/memtest32.efi
cp /tmp/memtest/memtest64.efi ./memtest/memtest64.efi
rm -rf /tmp/memtest
echo "Done"
