FROM rockylinux:8.9
RUN dnf install -y dnsmasq procps-ng ipxe-bootimgs-x86; dnf clean all;
COPY --chmod=644 --chown=dnsmasq:dnsmasq dnsmasq.conf /etc/dnsmasq.conf
COPY --chmod=644 --chown=dnsmasq:dnsmasq dhcp-hostsfile /etc/dhcp-hostsfile
COPY --chmod=644 --chown=dnsmasq:dnsmasq dhcp-optsfile /etc/dhcp-optsfile
EXPOSE 67/udp
ENTRYPOINT dnsmasq -k

