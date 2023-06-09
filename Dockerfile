FROM linuxserver/yq:3.2.2

WORKDIR /app

COPY ./src/script.sh ./src/init.sh .

VOLUME /app/requests

ENTRYPOINT [ "./init.sh" ]
