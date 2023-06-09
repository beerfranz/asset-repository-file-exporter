#!/usr/bin/env sh


REQUESTS_DIR=/app/requests
TMP_DIR=/tmp/requests

mkdir -p ${TMP_DIR}

for yaml in $(find ${REQUESTS_DIR} -type f -name *.yml); do
	echo "convert ${yaml} to json"
	file=$(basename ${yaml})
	yq . ${yaml} > ${TMP_DIR}/${file}.json
done

for json in $(find ${TMP_DIR} -type f -name *.json); do
	echo "find file ${json}"
	data_file=/tmp/data.json

	method=$(jq -r .request.method ${json})
	path=$(jq -r .request.path ${json})
	jq -r .data ${json} > ${data_file}

	request="curl -X ${method} -s -k -H 'Content-type: application/json' ${ASSET_REPOSITORY_URL}${path} -d @${data_file}"
	http_code=$(eval "${request} -w '%{http_code}' -o /dev/null")
	case $http_code in
		"200"|"201")
		;;
		*) echo "Error, bad response code ${http_code}";
			echo "request: ${request}"
			echo -n "data: "
			jq -c . ${data_file}
			# eval ${request}
		exit 1
	esac

done

for tmp in $(find ${TMP_DIR} -type f -name *.json); do
	rm ${tmp}
done
