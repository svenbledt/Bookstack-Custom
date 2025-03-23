FROM linuxserver/bookstack

LABEL maintainer="sven@bledt.dev"
LABEL name="BookStack"
LABEL version="1.0"
LABEL description="BookStack is a simple, self-hosted, easy-to-use platform for storing and sharing documentation."

COPY ./overrides /app/www/
