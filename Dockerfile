FROM golang:alpine as build
RUN apk --no-cache add git bzr mercurial 
WORKDIR /go/src
RUN go get -d upspin.io/cmd/...\ 
    && go install upspin.io/cmd/...\
    && go get -d aws.upspin.io/cmd/...\
    && go install aws.upspin.io/cmd/upspin-setupstorage-aws\
    && go install aws.upspin.io/cmd/upspinserver-aws\
    && go get drive.upspin.io/cmd/...\
    && go install drive.upspin.io/cmd/upspin-setupstorage-drive\
    && go install drive.upspin.io/cmd/upspinserver-drive\
    && go get -d dropbox.upspin.io/cmd/...\
    && go install dropbox.upspin.io/cmd/upspin-setupstorage-dropbox\
    && go install dropbox.upspin.io/cmd/upspinserver-dropbox\
    && go get -d gcp.upspin.io/cmd/... \
    && go install gcp.upspin.io/cmd/upspin-setupstorage-gcp\
    && go install gcp.upspin.io/cmd/upspinserver-gcp

FROM alpine
RUN apk --no-cache add ca-certificates
LABEL maintainer="jabbrwcky@gmail.com"

WORKDIR /upspin

COPY --from=build /go/bin/* ./
ADD start.sh ./

VOLUME "/upspin/data"
VOLUME "/upspin/letsencrypt"

EXPOSE 80
EXPOSE 443

ENV VARIANT=local

ENTRYPOINT [ "/upspin/start.sh" ]
