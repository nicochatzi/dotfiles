STATE_DIR:=${HOME}/.local/share/feeds
JOB=*/5 * * * * cd ${PWD} && make

run:
	nix-shell --run 'python3 check.py ${STATE_DIR}'
.PHONY: run

install:
	@mkdir -p ${STATE_DIR}
	@(crontab -l 2>/dev/null; echo '${JOB}')  | grep -vF '# ' | sort | uniq | crontab -
	@echo "crontab content:"
	@crontab -l | grep -vF '# '
.PHONY: install
