docker run -it -v --rm --name test \
-v ./sushy-emulator/ssl:/ssl \
-v ./sushy-emulator/ssh:/root/.ssh \
-v ./sushy-emulator/config:/config \
-v ./sushy-emulator/htpasswd:/htpasswd \
tgrivel/sushy-emulator:0.0.1 \
/env/bin/sushy-emulator --port 443 --config /config/config.py --interface 0.0.0.0 --ssl-certificate /ssl/sushy-emulator.crt --ssl-key /ssl/sushy-emulator.key --libvirt-uri "qemu+ssh://cloud-user@172.17.0.1/system"
