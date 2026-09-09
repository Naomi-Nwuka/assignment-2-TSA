FROM alpine:3.20

RUN apk add --no-cache \
    bash \ 
    iproute2 \     
    iputils \ 
    util-linux \
    procps \
    coreutils

WORKDIR /app

COPY app/ /app/

RUN chmod +x /app/diagnostic.sh /app/health-check.sh

ENTRYPOINT ["/app/diagnostic.sh"]



#############################################
# bash \ runs script
# iproute2 \ provides ip command 
# iputils \ provides ping
# util-linux \ provides utilities like uptime
# coreutils \ provides common linux commands
###############################################
