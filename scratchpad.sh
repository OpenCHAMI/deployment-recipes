sudo git pull origin 83-dev-integrate-keylime
ansible-playbook -i inventory.yaml -l keylime_server -K site.yaml
journalctl -u keylime_verifier.service -f
journalctl -u keylime_registrar.service -f

sudo systemctl status keylime_verifier.service
sudo systemctl status keylime_registrar.service
sudo systemctl status keylime_agent.service
sudo systemctl status keylime_tenant.service

pm -0 nid00003
pm -0 nid00004

pm -1 nid00003
pm -1 nid00004