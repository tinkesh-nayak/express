FROM ubuntu

WORKDIR /home

RUN apt update -y

RUN apt install git -y

RUN apt install nodejs -y

RUN apt install npm -y

COPY . .

EXPOSE 3000

RUN chmod +x /home/script.sh

ENTRYPOINT ["/home/script.sh"]

CMD ["foreman", "start"]
