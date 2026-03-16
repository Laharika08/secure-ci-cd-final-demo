FROM node:16-alpine3.14

ENV MAIN_DIR=/fatura-website-backend
WORKDIR ${MAIN_DIR}

COPY . .

RUN npm install

RUN npm run build

EXPOSE 5002
CMD [ "node", "./dist/src/app.js" ]