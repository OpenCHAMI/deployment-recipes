QUADLET
--------------------------------------------------------------------------------
This role drops quadlets for ochami head nodes.  
Creates files for each container in `/etc/containers/systemd`

## Variables
- `podman_quadlets`: a list of dictionaries defining a container quadlet
	- `name`: name of container 
	- `image`: image for container
	- `ports`: list of ports to map from host to container
	- `envs`: list of environment variables to set for container
        - `secrets`: a list of secrets to add to the container. Must already be created in podman
        - `init`: Boolean variable that if true runs the container with the `--init` flag
	- `device`: Add a device to the container
        - `work_dir`: Set the working directory of the container
	- `command`: Command to run in container. If not set it will run the entrypoint
	- `pre_start`: List of commands to run before container starts
	- `post_start`: List of commands to run after container starts

## Examples
```yaml
podman_quadlets:
  - name: cloud-init-server
    image: docker.io/library/python:latest
    volumes:
      - /data/cloud-init:/data/cloud-init
    ports:
      - 192.168.7.253:8000:8000
    secrets:
      - env_secret,type=env,target=ENVSECRET
      - file_secret,type=mount,target=/tmp/file.secret
    work_dir: /data/cloud-init
    command: python3 -m http.server
    pre_start:
      - mkdir -p /data/cloud-init
```
