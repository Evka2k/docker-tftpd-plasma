FROM alpine:latest
COPY overlay/ /

RUN apk --no-cache add tftp-hpa grub
RUN addgroup -S -g 101 tftpd && \
    export GRUB_VERSION=$(apk info grub | grep description | sed 's/grub-\(.*\) description:/\1/') && \
    wget "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/grub-bios-$GRUB_VERSION.apk" -O /tmp/grub-bios.apk && \
    tar -C / -xvf /tmp/grub-bios.apk && \
    rm -f /tmp/grub-bios.apk && \
    wget "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/grub-efi-$GRUB_VERSION.apk" -O /tmp/grub-efi.apk && \
    tar -C / -xvf /tmp/grub-efi.apk && \
    rm -f /tmp/grub-efi.apk && \
    adduser -s /bin/false -S -D -H -h /tftpboot -G tftpd -u 100 tftpd && \
    grub-mknetdir --net-directory=/tftpboot --subdir=/ -d /usr/lib/grub/i386-pc && \
    grub-mknetdir --net-directory=/tftpboot --subdir=/ -d /usr/lib/grub/x86_64-efi && \
    /tftpboot/plasma_boot/download.sh && \
    echo "Finished..."

#VOLUME /tftpboot/syslinux/plasma_boot/custom
EXPOSE 69/udp

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/in.tftpd", "-L", "-vvv", "-s", "-u", "tftpd", "/tftpboot"]
