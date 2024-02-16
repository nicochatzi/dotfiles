STATE_DIR:=${HOME}/.local/share/feeds

run:
	nix-shell --run 'python3 check.py ${STATE_DIR}'
.PHONY: run

install:
	mkdir -p ${STATE_DIR}
	echo '*/5 * * * * make -f ${PWD}/makefile run' | crontab -
.PHONY: install
