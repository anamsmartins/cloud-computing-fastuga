FROM node:latest
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm -i stream-browserify agent-base
RUN npm install

COPY . .

RUN cp /usr/src/app/.env.production /usr/src/app/.env

EXPOSE 5174
ENTRYPOINT ["npm", "run", "dev", "--", "--port", "5174"]