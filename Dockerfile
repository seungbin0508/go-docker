FROM golang:1.23-alpine AS build
WORKDIR /usr/app/src

# copy necessary module scripts
COPY go.mod go.sum ./

# install dependencies (i.e. modules)
RUN go mod download

# copy source code
COPY ./src ./

# compile
RUN CGO_ENABLED=0 go build -o /go/bin/app main.go

FROM gcr.io/distroless/base-debian12 AS runtime
WORKDIR /
COPY --from=build /go/bin/app /
USER nonroot:nonroot
ENTRYPOINT ["/app"]