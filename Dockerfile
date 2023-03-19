FROM ubuntu

WORKDIR /home

RUN apt update -y

RUN apt install git -y

RUN apt install nodejs -y

RUN apt install npm -y

RUN git clone https://github.com/tinkesh-nayak/express.git

EXPOSE 3000

RUN chmod +x /home/express/script.sh

ENTRYPOINT ["/home/express/script.sh"]

CMD ["foreman", "start"]
