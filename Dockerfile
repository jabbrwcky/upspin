FROM golang:alpine as build
RUN apk --no-cache add git bzr mercurial
#FROM golang:alpine
 
WORKDIR /go/src
RUN git clone https://github.com/upspin/upspin upspin.io
WORKDIR /upspin
RUN go install upspin.io/cmd/...

FROM alpine
RUN apk --no-cache add ca-certificates

WORKDIR /upspin
# RUN addgroup -g 1000 upspin && \
#    adduser -S -G upspin -u 1000 upspin && \
#    echo "export PATH=$PATH:/home/upspin/bin" > /home/upspin/.profile

# USER 1000/1000

COPY --from=build /go/bin/* ./

VOLUME "/upspin/data"
VOLUME "/upspin/letsencrypt"

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "/upspin/upspinserver", "-config", "/upspin/data/config", "-web", "-serverconfig", "/upspin/data/server", "-letscache", "/upspin/letsencrypt" ]
