sudo git pull origin 83-dev-integrate-keylime
ansible-playbook -i inventory.yaml -l keylime_server -K site.yaml
journalctl -u keylime_verifier.service -f
journalctl -u keylime_registrar.service -f