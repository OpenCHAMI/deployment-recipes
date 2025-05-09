# Keylime Verifier & Registrar Deployment

This directory contains Ansible playbooks and roles for deploying the Keylime Server (Keylime Verifier and Registrar) as Podman quadlets.

---

## Prerequisites
-------------

-   **Ansible** installed on your control machine.

-   A valid `inventory.yaml` file detailing the `keylime_server` host(s).

-   Appropriate network connectivity from hosts running Keylime Agents to the Keylime Server (Registrar & Verifier).

## Directory Structure
-------------------

```
lanl/podman-quadlets/keylime/
├── roles/
│   └── keylime_verifier/
│       ├── tasks/
│       │   └── main.yaml
│       └── ...
├── site.yaml
├── inventory.yaml (example; not stored in repo)
└── ...

```

Pre-Deployment Configuration
----------------------------

By default, this deployment will **generate** self-signed certificates for the Keylime Verifier. If you would like to use **existing** or custom certificates, do the following:

1.  **Edit** `lanl/podman-quadlets/keylime/roles/keylime_verifier/tasks/main.yaml`.

2.  Within the **"Configure Verifier"** section, locate the variable `tls_dir` or any reference to `generate`.

3.  The default option `generate` generates certificates and stores them at tls_dir = /var/lib/keylime/cv_ca if you want to use your own certificates, Update it to point to your certificate directory. Refer to [Redhat Keylime Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/security_hardening/assembly_ensuring-system-integrity-with-keylime_security-hardening#configuring-keylime-verifier_assembly_ensuring-system-integrity-with-keylime) for more details. 

To load existing keys and certificates in the configuration, define their location in the verifier configuration. The certificates must be accessible by the keylime user, under which the Keylime services are running.

Create a new .conf file in the /etc/keylime/verifier.conf.d/ directory, for example, /etc/keylime/verifier.conf.d/00-keys-and-certs.conf, with the following content:
```
[verifier]
tls_dir = /var/lib/keylime/cv_ca
server_key = </path/to/server_key>
server_key_password = <passphrase1>
server_cert = </path/to/server_cert>
trusted_client_ca = ['</path/to/ca/cert1>', '</path/to/ca/cert2>']
client_key = </path/to/client_key>
client_key_password = <passphrase2>
client_cert = </path/to/client_cert>
trusted_server_ca = ['</path/to/ca/cert3>', '</path/to/ca/cert4>']
```


> **Note**: Custom certificates should also be placed on the Keylime Agents or otherwise trusted by the Agents to ensure secure communication.

Deploying the Keylime Server
----------------------------

Once you have your **inventory** and any **certificate configuration** sorted out, run the following command from this directory:

```
ansible-playbook -i inventory.yaml -l keylime_server -K site.yaml

```

-   `-i inventory.yaml`: Uses your specified inventory file (replace with the actual path if needed).

-   `-l keylime_server`: Limits the playbook run to hosts in the `keylime_server` group.

-   `-K`: Prompts for privilege escalation password (sudo).

-   `site.yaml`: The main playbook which includes tasks to install and configure the Keylime Verifier & Registrar.

Upon successful execution:

-   The **Keylime Verifier** and **Keylime Registrar** services will be installed and configured as Podman containers (quadlets).

-   Services should be running and ready to accept agent registrations.

To verify the status of keylime verifier and registrar 

```
systemctl status keylime_verifier
systemctl status keylime_registrar
```

Default Keys & Certificates
---------------------------

If you use the default key generation:

-   The Keylime Verifier's self-signed CA and associated keys will be located in `/var/lib/keylime/cv_ca/` on the Keylime Server host.

-   These CA certificates must be **imported by the Keylime Agent** hosts so that the Agents can securely connect and attest to the server.

> **Tip**: Make sure your Keylime Agent configuration (`keylime.conf`) points to the correct CA certificate path and can verify the Verifier's SSL connection.

Next Steps
----------

1.  **Deploy & Configure Keylime Agents**

    -   On each node you wish to attest, install and configure the Keylime Agent.

    -   Ensure the Agent's `keylime.conf` references the CA used by the Verifier.

2.  **Testing & Validation**

    -   Verify that each agent can register with the registrar (`keylime_registrar`) and attests successfully to the verifier.

3.  **Security Hardening**

    -   If you are running in a production environment, consider using official or enterprise-signed certificates and locked-down firewall rules.

* * * * *

### Troubleshooting

-   **Service Fails to Start**: Check logs in `/var/log/` or Podman logs for containers to see if certificate paths or other environment variables are set incorrectly.

-   **Agent Cannot Connect**: Ensure host firewalls allow the Verifier/Registrar ports (default 8890/8892 or custom if changed).

-   **Certificate Errors**: Confirm that Agents trust the CA certificate used by the Verifier.

* * * * *


For more details on Keylime usage and advanced configuration, consult the [Keylime documentation](https://keylime.dev/) and the official Red Hat [Keylime Guide](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/security_hardening/assembly_ensuring-system-integrity-with-keylime_security-hardening) if you are on RHEL systems.