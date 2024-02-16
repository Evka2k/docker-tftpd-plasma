FROM alpine:latest
COPY overlay/ /

ARG SYSLINUX_PACKAGE="https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/syslinux-6.04_pre1-r15.apk"

RUN apk --no-cache add tftp-hpa
RUN addgroup -S -g 101 tftpd && \
    adduser -s /bin/false -S -D -H -h /tftpboot -G tftpd -u 100 tftpd && \
    mkdir /tmp/syslinux && \
    wget "$SYSLINUX_PACKAGE" -O /tmp/syslinux/syslinux.apk && \
    tar -C /tmp/syslinux -xvf /tmp/syslinux/syslinux.apk && \
    mkdir -p /tftpboot/pxelinux.cfg && \
    cp -r /tmp/syslinux/usr/share/syslinux /tftpboot && \
    rm -rf /tmp/syslinux && \
    ln -s ../pxelinux.cfg /tftpboot/syslinux/pxelinux.cfg && \
    ln -s ../plasma_boot /tftpboot/syslinux/plasma_boot && \
    ln -s ../../pxelinux.cfg /tftpboot/syslinux/efi64/pxelinux.cfg && \
    ln -s ../../plasma_boot /tftpboot/syslinux/efi64/plasma_boot && \
    ln -s ../plasma_boot/menu.cfg /tftpboot/pxelinux.cfg/default && \
    /tftpboot/syslinux/plasma_boot/download.sh

VOLUME /tftpboot/syslinux/plasma_boot/custom
EXPOSE 69/udp

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/in.tftpd", "-L", "-vvv", "-s", "-u", "tftpd", "/tftpboot"]
