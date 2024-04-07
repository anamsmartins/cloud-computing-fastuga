FROM node:latest
WORKDIR /usr/src/app

COPY package-lock.json .
COPY package.json .
RUN npm install

COPY index.js .

EXPOSE 8080
ENTRYPOINT ["node", "index.js"]
