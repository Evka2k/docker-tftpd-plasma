FROM alpine:latest
COPY overlay/ /

RUN apk --no-cache add tftp-hpa grub grub-bios grub-efi
RUN addgroup -S -g 101 tftpd && \
    adduser -s /bin/false -S -D -H -h /tftpboot -G tftpd -u 100 tftpd && \
    grub-mknetdir --net-directory=/tftpboot --subdir=/ -d /usr/lib/grub/i386-pc && \
    grub-mknetdir --net-directory=/tftpboot --subdir=/ -d /usr/lib/grub/x86_64-efi && \
    /tftpboot/plasma_boot/download.sh && \
    echo "Finished..."

#VOLUME /tftpboot/syslinux/plasma_boot/custom
EXPOSE 69/udp

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/in.tftpd", "-L", "-vvv", "-s", "-u", "tftpd", "/tftpboot"]
