FROM alpine:3.19

RUN apk update && \
    apk add \
      cowsay \
      fortune \
      --no-cache \
      --repository https://dl-cdn.alpinelinux.org/alpine/v3.19/main \
      --repository https://dl-cdn.alpinelinux.org/alpine/v3.19/community \
      --repository https://dl-3.alpinelinux.org/alpine/edge/testing && \
    rm -rf /var/cache/apk/* && \
    echo "Deleting cows that are too big (greater than 40 width or 20 height) (or a bit inappropraite for a motd)" 1>&2 && \
    (  \
      cd /usr/share/cows/; \
      rm \
        "beavis.zen.cow" \
        "blowfish.cow" \
        "bud-frogs.cow" \
        "cheese.cow" \
        "daemon.cow" \
        "dragon.cow" \
        "dragon-and-cow.cow" \
        "eyes.cow" \
        "ghostbusters.cow" \
        "head-in.cow" \
        "kiss.cow" \
        "kitty.cow" \
        "ren.cow" \
        "sodomized.cow" \
        "stegosaurus.cow" \
        "surgery.cow" \
        "telebears.cow" \
        "turkey.cow" \
        "turtle.cow" \
    )

CMD "/usr/bin/cowsay"
