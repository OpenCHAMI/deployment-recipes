PODMAN SECRETS
--------------------------------------------------------------------------------
This role creates podman secrets. 
Currently the `podman_secrets` module does play very nice with re-running this role.
For the time being `force` is set to `true` meaning the secrets will get recreated everytime it is run.  

## Variables
- `podman_secrets`: A list of dictionaries defining a secret
	- `name`: name of secret
	- `data`: A string or contents of a file. Probably a good idea for this to be vault encrypted.

## Examples
```yaml
podman_secrets:
  - name: my-secret
    data: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          31316239313237646134323165633538333038653463333663613536333832393933333530343533
          3837633861623666393131373663623030666563666239380a626437613132393064613330376331
          36373433373938313661383639393265663231333438623239336262336661346334363432313132
          3633343039323633310a353636613936643235306663383465313133316334333133653735643662
          3864
```
