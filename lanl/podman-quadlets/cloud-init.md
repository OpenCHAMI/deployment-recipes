# The new cloud-init

The API changed pretty significantly in this update/re-factor

Admin facing endpoints:
```
/admin/cluster-defaults
/admin/instance-info/{id}
/admin/groups
/admin/groups/{id}
/admin/impersonation/{id}/[meta-data, user-data, vendor-data, {group}.yaml]
```

Node facing endpoints
```
/[meta-data, user-data, vendor-data, {group}.yaml]
```
The node facing endpoints are meant to service the nodes that use cloud-init. There is some functionality that reads the client IP and does some look ups. These won't work on a management node


You can set cluster defaults via a POST to the `/admin/cluster-defaults` endpoint
```json
{
        "cluster-name": "demo",
        "public-keys": [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfpY39k6BV2lmw7KERBfiQpW9isWW7R9qnrpY4hGGkmWqQTJNKfPNjjLDfNEsVkzscb9c8Pwrf2bhkgIm+A55sfOcVhvZ7EK6Bdra9enT0jrpbFpDZ7rd83GCmo4x+1uUa9XDTmE7OoSwX0v+BCYG7Q33mJdR3HSRygkBIeVLc29/tYo7oKnRMHcfKYzzI8YpoIe3zUjQCHuKdMV/ip3Xp6nB6f4nx6w6k09s6yks/m3t5kjgp+xI9lgE53CvOVEZdqD7IJZSBBwLrKwh35iyhBEB1Y69QxIhiCeIAsSOMn/AJ3vlCYV3YlnhhxepfdKGXyghPamQWTVdaogGoRnjEqW7qYmdtmk0V1UzagqwT5EwV/I7Gbqj7W6vCG174fv13txOFubonxDo4BQeVXZejTdxasioNevjU6Musyizu9Cl+NDrvamlGKJrJtWwfb8PtMqP+mbQHVaKLFpbgT2Wm4dVZfRxV8nEYTU+4KCo3dMYGd8y7GK+95UEepehPXQk= root@st-head.si.usrc"
        ],
	"base-url": "http://10.0.0.1:27777/cloud-init"
}
```
Then
```bash
curl -X POST $CLOUD_INIT_URL/admin/cluster-defaults -H "Content-Type: application/json" -d @config.json
```

You can view the defaults with a GET from the same endpoint:
```bash
curl -s -X GET $CLOUD_INIT_URL/admin/cluster-defaults | jq
```
## Data and Actions
The cloud-init re-factor should make it easier to manage a lot of configs. Versus the old way which was basically a single giant payload/file to manage. 

In doing this we broke things out into two basic features: `meta-data` and `file`. In ansible terms this would be similar to inventory and roles. 

The `meta-data` is where variables are stored. These variables are put into groups that can be assigned to a node and a node can have multiple groups. There is no restriction on the group naming outside like alpha-numeric stuff. 

An example `meta-data` payload would look something like:
```yaml
name: compute
description: "Compute group meta-data"
meta-data:
  chrony_server: 172.16.0.254
```
You can have multiple key-value pairs. POSTing this to the `/admin/groups` endpoint will create the `compute` group and any nodes in that group will have access to through the `/meta-data` endpoint. 

You can see all group content via:
```bash
curl $CLOUD_INIT_URL/admin/groups
```

The `file` type is intended to host the cloud-init modules. It looks exactly like the `user-data` format. The `file` type is also assigned via groups and a node can be a member of multiple groups with different `file` contents.  

An example `file` payload:
```yaml
name: chrony
description: "chrony.conf template"
file:
  encoding: plain
  content: |
    ## template: jinja
    #cloud-config
    merge_how:
     - name: list
       settings: [append]
     - name: dict
       settings: [no_replace, recurse_list]
    write_files:
      - content: |
          server {{ ds.meta_data.instance_data.v1.vendor_data.groups.chrony.chrony_server }} iburst
          driftfile /var/lib/chrony/drift
          makestep 1.0 3
          rtcsync
          keyfile /etc/chrony.keys
          leapsectz right/UTC
          logdir /var/log/chrony
        path: /etc/chrony.conf
    runcmd:
      - systemctl restart chronyd
```
POSTing this to `/admin/groups` will create the `chrony` group and any nodes that are a member of the chrony group will execute these cloud-init modules on boot. This payload has a jinja2 template in it. This is optional and you could put the `chrony_server` value in directly.

It's also possible to combine `meta-data` and `file` into a single group. 
```yaml
name: combined
description: "Combined group with meta-data and file contents"
meta-data:
  key: value
file:
  encoding: plain
  content: |
    ## template: jinja
    #cloud-config
    runcmd:
      - echo {{ ds.meta_data.instance_data.v1.vendor_data.groups.combined.key }}
```

## Merging multiple cloud-configs
A couple differences between the older version of cloud-init and this new one is how the cloud-init configs are merged. Instead of merge-replace, where if multiple groups have different `write_files` then the last group's `write_files` "wins", the `write_files` from the node's groups are merged-appended. The second big difference is where the merging happens. The old cloud-init did the merging on the server side, the new one takes advantage of the built-in cloud-init merging and it happens on the client at boot time. 

For example, given two cloud-configs:
```yaml
runcmds:
  - echo hello1
  - echo hello2
```
```yaml
runcmds:
  - echo hello3
```

The old way of merging would have resulted in:
```yaml
runcmds:
  - echo hello3
```

The new way will result in
```yaml
runcmds:
  - echo hello1
  - echo hello2
  - echo hello3
```

This merging is done on the client side using cloud-inits `vendor-data` with the `include` file directive.

The cloud-init client will look for three files in this order
- meta-data
- user-data
- vendor-data

`meta-data` will contain all the variables from each assigned group. They will be in this format:
```yaml
instance_data:
  v1:
    vendor_data:
      groups:
        group1:
        group2:
```
`meta-data` will include other generated data that we can cover later.

`user-data` is blank. We are not using `user-data` at all at the moment

`vendor-data` will be a file that has a list of URLs to all the groups. If a group has `file` data in it, this is where cloud-init will go grab that data. Example:
```yaml
#include
http://10.0.0.1:27777/cloud-init/group1.yaml
http://10.0.0.1:27777/cloud-init/group2.yaml
```
the cloud-init client will iterate over these and GET them, then do a merge-append on all the cloud-config data it finds. If a group doesn't have `file` data then the config will be empty (cloud-init will complain about this but won't fail). 

## Impersonation
it's useful as an admin to be able to see what is stored in cloud-init. We do this through `/admin/impersonation/{id}`. Here you can see the `meta-data`, `vendor-data`, and all the `{group.yaml}` contents

```bash
curl $CLOUD_INIT_URL/admin/impersonation/x1000c1s7b9n0/meta-data
curl $CLOUD_INIT_URL/admin/impersonation/x1000c1s7b9n0/vendor-data
curl $CLOUD_INIT_URL/admin/impersonation/x1000c1s7b9n0/group1.yaml
```

This will tell you what variables a specific node has assigned, and what cloud-configs it will use. 

## Being super secure (I hope)
We Dropped the unsecure vs. secure endpoints and instead opted to go with using wireguard to create a secure tunnel to the cloud-init server. This requires cloud-init to be able to create wireguard interfaces on both the server and client. The server side is all done in the code but the client side must be configured before cloud-init starts. 

The wireguard [quickstart](https://www.wireguard.com/quickstart/) can explain how to setup a tunnel better than I can and so I won't repeat it here. 

The way we set it up using the cloud-init server is to enable a `/wg-init` endpoint. If you post to that endpoint with a payload that looks like:
```json
{ 
    "public_key": "<public_key>" 
}
```

You will get back a payload that looks like:
```json
{
   "client-vpn-ip": "10.0.0.2",
   "message": "WireGuard tunnel created successfully",
   "server-ip": "10.0.0.1",
   "server-port": "58036",
   "server-public-key": "XKQGehVLbVEik4WFehWMwGrsBV4k8pBzwBUu//wL8Ww="
 }
```
This should be enough for you to create the tunnel. 