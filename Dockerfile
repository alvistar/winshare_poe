ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8
# https://www.waveshare.com/wiki/PoE_HAT_(B)
ARG WAVESHARE_CODE_URL=https://www.waveshare.com/w/upload/b/b7/PoE_HAT_B_code.7z

RUN apk add fish i2c-tools linux-headers alpine-sdk gcc6 p7zip
ADD $WAVESHARE_CODE_URL /opt/poe/poe.7z
# COPY PoE_HAT_B_code /opt/poe.7z

WORKDIR /opt/poe
RUN p7zip -d /opt/poe/poe.7z
WORKDIR /opt/poe/c
RUN make clean
RUN make CC=gcc-6

# CMD [ "sleep", "infinity" ]

FROM $BUILD_FROM
COPY --from=0 /opt /opt
CMD ["/opt/poe/c/main"]