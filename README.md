# OpenCHAMI Deployment Recipes (Organization-Specific)

This repository contains **organization-specific deployment patterns** for OpenCHAMI. These recipes are **not officially supported** for general use and may require customization for your environment.

For new users, we recommend starting with the **[OpenCHAMI Tutorial](https://openchami.org/docs/tutorial/)** or the **[Release RPM](https://github.com/OpenCHAMI/release)** for a standardized quadlet-based deployment.

## Contents

- [`quickstart/`](./quickstart/) – General quickstart for Docker Compose (**Deprecated** - use the [Tutorial](https://openchami.org/docs/tutorial/) instead)
- [`quickstart-pcs/`](./quickstart-pcs/) – Quickstart with PCS and Sushy-tools (**Deprecated** - use the [Tutorial](https://openchami.org/docs/tutorial/) instead)
- [`dell/`](./dell/) – Dell-specific deployment recipes
- [`lbnl/`](./lbnl/) – LBNL-specific deployment recipes

## Recommended for New Users

If you're new to OpenCHAMI, we recommend these resources instead:

- **[OpenCHAMI Tutorial](https://openchami.org/docs/tutorial/)** – The best way to learn OpenCHAMI. Uses Podman Quadlets for a standardized deployment.
- **[Release RPM](https://github.com/OpenCHAMI/release)** – Deploy OpenCHAMI as Podman Quadlets on Red Hat-based systems. Companion to the tutorial.

## Alternative Deployment Methods

OpenCHAMI supports multiple deployment approaches:

- **[kube-deploy](https://github.com/OpenCHAMI/kube-deploy)** – Deploy OpenCHAMI on Kubernetes using Helm charts.
- **[openchami-operator](https://github.com/OpenCHAMI/openchami-operator)** – Use the OpenCHAMI operator for advanced Kubernetes orchestration.
- **[integration-sandbox](https://github.com/OpenCHAMI/integration-sandbox)** – Test OpenCHAMI in a sandbox environment.

## Deprecation Notice

The `quickstart/` and `quickstart-pcs/` directories are **deprecated** in favor of the [OpenCHAMI Tutorial](https://openchami.org/docs/tutorial/). They are kept for historical reference only and are no longer maintained.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
