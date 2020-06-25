FROM golang:alpine
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src
COPY . .
RUN go get -d -v && go build -o /go/bin/entrypoint
ENTRYPOINT ["entrypoint"]
CMD localhost:6379
