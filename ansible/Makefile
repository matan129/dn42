BASE_ANSIBLE_PLAYBOOK_COMMAND	:= ansible-playbook $(ANSIBLE_PLAYBOOK_ARGS)
ANSIBLE_PLAYBOOK_EXTRA_ARGS		:=

PLAYBOOK_TARGETS				:= $(shell ls playbooks/*.yml | sed 's|playbooks/||g' | sed 's|.yml||g')

$(foreach p, $(PLAYBOOK_TARGETS), $(eval play-$(p): .play-$(p)))

.PHONY: .play-%
.play-%: write-vault-password
	$(BASE_ANSIBLE_PLAYBOOK_COMMAND) playbooks/$*.yml

.PHONY: list-playbooks
list-playbooks:
	@echo $(PLAYBOOK_TARGETS)

.PHONY: add-bgp-peers
add-bgp-peers: ANSIBLE_PLAYBOOK_EXTRA_ARGS=--tags adding_peers
add-bgp-peers: .play-bgp

.PHONY: write-vault-password
write-vault-password: .vault_pass

.vault_pass:
	@$(VAULT_PASS_COMMAND) > .vault_pass

.PHONY: print-pubkeys
print-pubkeys: write-vault-password
	@ansible bgp_servers -m debug -a "msg={{ wg_private_key }}" | grep msg | awk '{ print $$2 }' | tr -d '"' | wg pubkey

.PHONY: encrypt-string
encrypt-string: write-vault-password
	ansible-vault encrypt_string --encrypt-vault-id default --name $(name) $(value)

.PHONY: encrypt-file
encrypt-file: write-vault-password
	ansible-vault encrypt --encrypt-vault-id default $(file)
