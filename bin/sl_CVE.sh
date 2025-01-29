#!/usr/bin/bash

refresh=""
check=1
while getopts "cr" OPT; do
	case "$OPT" in
	c) check=0 ;;
	r) refresh="-r" ;;
	esac
done
shift $(($OPTIND-1))

curl --fail -sSOL https://kerncvs.suse.de/MAINTAINERS 

if [ -z "$1" ]; then
	exit 1
fi

readarray -t CVES < <(sed -n 's/.*\(CVE-[-0-9]*\).*/\1/p' "$1")
declare -a RETVALS=()

function wait_and_queue_res() {
	wait "$1"
	RETVALS+=( $? )
}

if [ "$check" -eq 1 ]; then
	declare -a PIDS=()

	for cve in "${CVES[@]}"; do
		./scripts/check-kernel-fix $refresh "$cve" &> "$cve" &
		PID="$!"
		PIDS+=( "$PID" )
		if [ -n "$refresh" ]; then 
			wait_and_queue_res "$PID"
			refresh=""
		else
			sleep 1
		fi
	done

	for PID in "${PIDS[@]}"; do
		wait_and_queue_res "$PID"
	done

	let idx=0
	for cve in "${CVES[@]}"; do
		echo >>"$cve"
		echo "Retval: ${RETVALS[$idx]}" >>"$cve"
		let idx++
	done
else
	for cve in "${CVES[@]}"; do
		RET="$(tail -1 "$cve")"
		RETVALS+=( ${RET##* } )
	done
fi

for cve in "${CVES[@]}"; do
	RET="${RETVALS[0]}"
	RETVALS=( "${RETVALS[@]:1}" )
	if [ "$RET" -ne 0 ]; then
		continue
	fi
	clear
	echo "=== $cve ==="
	echo "https://bugzilla.suse.com/buglist.cgi?quicksearch=$cve"
	echo
	if ! grep -qE 'NO ACTION NEEDED|No codestream affected' "$cve"; then
		readarray -t EMAILS < <(sed -n 's/Experts candidates: *//; T; s/ subsystem.*//; s/\([^ ]*\) (\([0-9]*\)) */\2 \1\n/g; s/\n$//mp' "$cve" | sort -n)
		echo "E-mails:"
		OLD_IFS="$IFS"
		IFS=$'\n'
		echo "${EMAILS[*]}"
		IFS="$OLD_IFS"
		EMAIL="${EMAILS[0]#[0-9]* }"
		EMAIL="${EMAIL%%@*}"
		NAME="$(grep -F "$EMAIL" MAINTAINERS | sed 's/M: \([^ ]*\) .*/\1/; q')"
		echo
		echo ----------------------
		echo "${NAME:-${EMAIL}}, could you take care [1] of this, please?"
		echo
		echo "[1] https://wiki.suse.net/index.php/SUSE-Labs/Kernel/Security"
		echo
	else
		echo ----------------------
	fi
	cat "$cve"
	read
	rm "$cve"
done

rm MAINTAINERS
