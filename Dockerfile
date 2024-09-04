FROM golang:1.22.5

WORKDIR /app

COPY . .

RUN go build -o /shortlet-api

EXPOSE 8080

CMD ["/shortlet-api"]