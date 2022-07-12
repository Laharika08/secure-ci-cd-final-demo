FROM node:16-alpine3.14

ENV USER=nodejs
ENV SERVICE_NAME=service
RUN addgroup -S nodejs && adduser \
    --disabled-password \
    --gecos "" \
    -s '/bin/sh' \
    --ingroup "$USER" \
    "$USER"


RUN mkdir /home/nodejs/${SERVICE_NAME}
RUN chown nodejs:nodejs /home/nodejs/${SERVICE_NAME}

USER nodejs

WORKDIR /home/nodejs/${SERVICE_NAME}

RUN chmod -R 777 /home/nodejs/${SERVICE_NAME}

COPY package.json .

RUN npm set progress=false && \
  npm i --silent

COPY . .