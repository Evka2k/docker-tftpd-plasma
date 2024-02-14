FROM alpine:latest
COPY overlay/ /

#LABEL org.opencontainers.image.title="tftpd"
#LABEL org.opencontainers.image.description="tftpd on alpine linux"
#LABEL org.opencontainers.image.licenses="MIT"
#LABEL org.opencontainers.image.authors="Winston Astrachan"

ARG SYSLINUX_PACKAGE="https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/syslinux-6.04_pre1-r15.apk"

RUN apk --no-cache add tftp-hpa
RUN <<EOF
    set -eux
    mkdir /data
    addgroup -S -g 101 tftpd
    adduser -s /bin/false -S -D -H -h /tftpboot -G tftpd -u 100 tftpd
    mkdir /tmp/syslinux
    wget "$SYSLINUX_PACKAGE" -O /tmp/syslinux/syslinux.apk
    tar -C /tmp/syslinux -xvf /tmp/syslinux/syslinux.apk
    mkdir -p /tftpboot/pxelinux.cfg
    cp -r /tmp/syslinux/usr/share/syslinux /tftpboot
    rm -rf /tmp/syslinux
    ln -s ../pxelinux.cfg /tftpboot/syslinux/pxelinux.cfg
    ln -s ../plasma_boot /tftpboot/syslinux/plasma_boot
    ln -s ../../pxelinux.cfg /tftpboot/syslinux/efi64/pxelinux.cfg
    ln -s ../../plasma_boot /tftpboot/syslinux/efi64/plasma_boot
    ln -s ../plasma_boot/menu.cfg /tftpboot/pxelinux.cfg/default
    mkdir -p /tmp/memtest
    wget https://www.memtest.org/download/v7.00/mt86plus_7.00.binaries.zip -O /tmp/memtest/memtest.zip
    unzip -d /tmp/memtest -x /tmp/memtest/memtest.zip
    cp /tmp/memtest/memtest32.efi /tftpboot/plasma_boot/memtest32.efi
    cp /tmp/memtest/memtest64.efi /tftpboot/plasma_boot/memtest64.efi
    rm -rf /tmp/memtest
EOF

VOLUME /tftpboot
EXPOSE 69/udp

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/in.tftpd", "-L", "-vvv", "-s", "-u", "tftpd", "/tftpboot"]
