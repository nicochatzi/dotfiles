STATE_DIR:=${HOME}/.local/share/feeds

run:
	python3 check.py ${STATE_DIR} >> ${STATE_DIR}/log
.PHONY: run

find:
	@$(eval store=$(shell ls $(STATE_DIR) | fzf))
	@$(eval selected=$(shell jq -r '.[] | "\(.title) - \(.link)"' $(STATE_DIR)/$(store) | fzf))
	@if [ -n "$(selected)" ]; then \
		xdg-open `echo "$(selected)" | sed 's/.* - //'`; \
	fi
.PHONY: find
