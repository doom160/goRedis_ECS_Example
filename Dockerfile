FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src
COPY . .
RUN go get -d -v && go build -o /tmp/entrypoint

#FROM golang:alpine
FROM alpine
COPY --from=builder /tmp/entrypoint /home/entrypoint
ENTRYPOINT /home/entrypoint
CMD localhost:6379
