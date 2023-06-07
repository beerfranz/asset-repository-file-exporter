FROM linuxserver/yq:3.2.2

WORKDIR /app

COPY ./src/script.sh .

VOLUME /app/requests

ENTRYPOINT [ "./script.sh" ]
