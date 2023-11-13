## build
FROM golang:1.19-alpine AS build

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache gcc musl-dev linux-headers

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN CGO_ENABLED=0 GOOS=linux go mod download && go mod verify

# 将源代码复制到映像中
COPY . .
RUN go build -v -o /usr/local/bin/baseweb ./cmd

#EXPOSE 8080
#CMD ["app"]


## deploy
# FROM gcr.io/distroless/base-debian11
FROM alpine:3.17

WORKDIR /
COPY --from=build /usr/local/bin/baseweb .
#COPY --from=build /usr/src/app/.env ./.env

EXPOSE 9090

#USER nonroot:nonroot
#RUN chmod -R 777 /usr/local/bin/app

ENTRYPOINT ["/baseweb"]

