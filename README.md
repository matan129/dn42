# DN42 Setup

This repo contains tooling to set up my DN42 AS, AS4242420906 (aka `PASTEN-NET`).

The stack is -

* Bird2
* Multiple peers over Wireguard
* ROA checks, periodically updated
* Full support for DN42 HTTPS
* Full support for DN42 DNS with Bind9

Unsupported things for now:
* IPv6
* Non-Wireguard peers
* Babel/OSPF

This setup is tested with Ubuntu Server 22.04 LTS.

Inside the `ansible` dir you'll find all the roles and playbooks, in standard Ansible layout.
There's a handy `Makefile` to simplify the commands.

## Using this for your own AS

If you want to run this repo for your own AS, you'll have to change these files:
* [inventory](https://github.com/matan129/dn42/blob/master/ansible/inventory) - change to your own hosts. `spanner` is just a nickname of my server, you can change it as well.
* [as.yml](https://github.com/matan129/dn42/blob/master/ansible/group_vars/all/as.yml) - holds your ASN and your CIDR blocks.
* [peers.yml](https://github.com/matan129/dn42/blob/master/ansible/host_vars/spanner/peers.yml) - `internal_ip` is the DN42 IP of your node. The rest is details about the peered ASes. 
* [wireguard.yml](https://github.com/matan129/dn42/blob/master/ansible/host_vars/spanner/wireguard.yml) - use your private Wireguard key (all the peers are configured with the corresponding public key).
* [dn42_deploy](https://github.com/matan129/dn42/blob/master/ansible/roles/clone_registry/files/dn42_deploy) - this is an SSH key that's used to clone the [DN42 registry](https://git.dn42.dev/). The clone is used to generate ROA files for Bird. So, sign up for the registry and use your own SSH key.

Use `ansible-vault` to encrypt the private keys. 

### [Makefile](https://github.com/matan129/dn42/blob/master/ansible/Makefile) Targets

BGP:
* `bgp` - sets up the BGP peers.
* `add-bgp-peers` - runs `bgp`, but skips tasks that are not needed only when adding new peers.
* `e2e` - does everything (installations + BGP) 

Utils:
* `print-pubkeys` - extracts the Wireguard public keys from the `wg_private_key` hostvar (i.e. [wireguard.yml](https://github.com/matan129/dn42/blob/master/ansible/host_vars/spanner/wireguard.yml)).
* `encrypt-string` / `encrypt-file` - uses `ansible-vault` to encrypt content.

### Environment Variables
The makefile needs these environment variables:

* `VAULT_PASS_COMMAND` - Used to echo the `ansible-vault` password. For example `echo my-secret-password` or `lpass show ...` (if using Lastpass).
* `ANSIBLE_PLAYBOOK_ARGS` (optional) - extra args for `ansible-playbook`, like `--private-key /path/to/key`
