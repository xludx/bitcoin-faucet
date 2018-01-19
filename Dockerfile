# FROM node:6.9.5-alpine
FROM mhart/alpine-node:8.9.0

RUN apk add --no-cache make gcc g++ python
RUN apk add --no-cache vips-dev fftw-dev --repository https://dl-3.alpinelinux.org/alpine/edge/testing/
RUN npm install -g -s --no-progress yarn

RUN mkdir -p /app/data
WORKDIR /app
COPY package.json /app

RUN npm install
COPY . /app

CMD [ "npm", "start" ]
EXPOSE 3000
