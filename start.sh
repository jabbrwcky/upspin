#!/usr/bin/env sh
set -e

case $VARIANT in
    "gcp")
        var=-gcp
        ;;
    "aws")
        var=-aws
        ;;
    "drive")
        var=-drive
        ;;
    "dropbox")
        var=-dropbox
        ;;
esac

exec /upspin/upspinserver$var -config /upspin/data/config -serverconfig /upspin/data/server -letscache /upspin/letsencrypt $@
