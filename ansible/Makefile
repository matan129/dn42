BASE_ANSIBLE_PLAYBOOK_COMMAND	:= ansible-playbook --private-key ~/.ssh/scaleway_dn42
ANSIBLE_PLAYBOOK_EXTRA_ARGS		:=

.PHONY: add-bgp-peers
add-bgp-peers: ANSIBLE_PLAYBOOK_EXTRA_ARGS=--tags adding_peers
add-bgp-peers: bgp

.PHONY: bgp
bgp: write-vault-password
	$(BASE_ANSIBLE_PLAYBOOK_COMMAND) $(ANSIBLE_PLAYBOOK_EXTRA_ARGS) playbooks/bgp.yml

.PHONY: e2e
e2e: write-vault-password
	$(BASE_ANSIBLE_PLAYBOOK_COMMAND) $(ANSIBLE_PLAYBOOK_EXTRA_ARGS) playbooks/e2e.yml

.PHONY: write-vault-password
write-vault-password: .vault_pass

.vault_pass:
	lpass show --password "matan129@gmail.com/DN42/DN42 Ansible Vault" > .vault_pass

.PHONY: print-pubkeys
print-pubkeys: write-vault-password
	ansible bgp_servers -m debug -a "msg={{ wg_private_key }}" | grep msg | awk '{ print $$2 }' | tr -d '"' | wg pubkey

.PHONY: encrypt-string
encrypt-string: write-vault-password
	ansible-vault encrypt_string --encrypt-vault-id default --name $(name) $(value)

.PHONY: encrypt-file
encrypt-file: write-vault-password
	ansible-vault encrypt --encrypt-vault-id default $(file)
