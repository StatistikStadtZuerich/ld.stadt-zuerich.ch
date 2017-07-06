FROM node:6.10-onbuild

RUN npm install pm2 -g

ENV TRIFID_CONFIG config.ssz.json

ADD config.ssz.json /usr/src/app/
ADD pm2-config.yml /usr/src/app
#ADD data /usr/src/app/data

CMD ["pm2-docker", "pm2-config.yml"]
EXPOSE 8080
