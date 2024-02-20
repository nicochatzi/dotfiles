STATE_DIR:=${HOME}/.local/share/feeds

run:
	nix-shell --run 'python3 check.py ${STATE_DIR}'
.PHONY: run

find:
	@$(eval store=$(shell ls $(STATE_DIR) | fzf))
	@$(eval selected=$(shell jq -r '.[] | "\(.title) - \(.link)"' $(STATE_DIR)/$(store) | fzf))
	@if [ -n "$(selected)" ]; then \
		xdg-open `echo "$(selected)" | sed 's/.* - //'`; \
	fi
.PHONY: find
