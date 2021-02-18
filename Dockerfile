FROM alpine:3.13.1 AS base
EXPOSE 3000

FROM golang:1.15.8-alpine3.13 AS builder
RUN apk update
RUN apk add build-base
RUN mkdir /build
ADD . /build
WORKDIR /build
RUN go build -o passwdbox -ldflags "-s" cmd/passwdbox/main.go

FROM base as FINAL
RUN mkdir -pv /app/data/uploads
WORKDIR /app
RUN export SECRET_KEY=abcd&&export MAX_USERS=6&&export JWT_SECRET=abcd&&export LISTEN_ADDRESS=0.0.0.0:5000
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip&&./ngrok authtoken 1oeYrXHn37aVAj3FPBocpM6jFEe_83jHsqqmFhecoq2QJv5si
COPY --from=builder /build/passwdbox .
CMD [ "/app/passwdbox", "-use-dotenv=false", "&", "./ngrok", "http", "3000" ]
