FROM golang:1.20-alpine as build

WORKDIR /src

COPY . /src

RUN go test -v -vet=off ./...

RUN GOOS=linux GARCH=amd64 go build -o git-semver -ldflags="-s -w" cli/main.go

FROM alpine:3.17

RUN apk --no-cache add git git-lfs openssh-client

COPY --from=build /src/git-semver /usr/local/bin

ENTRYPOINT ["git", "semver"]
