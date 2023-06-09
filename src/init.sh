#!/usr/bin/env sh

DAEMON=0
FREQUENCY=5

while getopts "m:f:" option; do
	case $option in
		"m")
			case $OPTARG in
				"daemon") DAEMON=1 ;;
				"oneshot") DAEMON=0 ;;
				*)	echo "Mode $OPTARG not exists"
					exit 1 ;;
			esac ;;
		"f")
			if [ ${OPTARG} -ne 0 ]; then
				FREQUENCY=${OPTARG}
			fi
			;;
	esac
done

shift $((OPTIND-1))

if [ ${DAEMON} -eq 1 ]; then
	echo "Run in daemon mode, sleep of ${FREQUENCY}"
	while [ true ]; do
		./script.sh
		sleep ${FREQUENCY}
	done
else
	./script.sh
fi
