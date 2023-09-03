FROM golang:alpine as builder

WORKDIR /usr/src/app
# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /usr/local/bin/app .

# Final stage
FROM scratch
COPY --from=builder /usr/local/bin/app /usr/local/bin/app
CMD ["app"]
