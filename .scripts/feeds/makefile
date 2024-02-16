STATE_DIR:=${HOME}/.local/share/feeds

run:
	nix-shell --run 'python3 check.py ${STATE_DIR}'

install:
	mkdir -p ${STATE_DIR}
	crontab -e */5 * * * * make -f `pwd`/makefile > ${STATE_DIR}/cron.log 2>&1

