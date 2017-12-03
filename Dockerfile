FROM node:6-onbuild

RUN npm install pm2 -g
CMD pm2-docker start npm -- start

EXPOSE 8080
