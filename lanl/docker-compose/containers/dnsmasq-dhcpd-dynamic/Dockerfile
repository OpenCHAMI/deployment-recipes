FROM rockylinux:8.9
RUN dnf install -y dnsmasq procps-ng ipxe-bootimgs-x86 python3 python3-pip; dnf clean all;
COPY --chmod=644 --chown=dnsmasq:dnsmasq dnsmasq.conf /etc/dnsmasq.conf
COPY --chmod=555 --chown=dnsmasq:dnsmasq smd.py /bin/smd.py
RUN pip3 install requests 

EXPOSE 67/udp
ENTRYPOINT smd.py && dnsmasq -k

