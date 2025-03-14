FROM golang:1.23 AS build

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

COPY tracker.db ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /my-app

CMD ["/my-app"]

FROM alpine:edge AS final

WORKDIR /app

COPY --from=build /my-app /app/my-app
COPY --from=build /app/tracker.db /app/tracker.db

CMD ["/app/my-app"]