ARG MONGO_VERSION=8

FROM mongo:${MONGO_VERSION}

RUN mkdir -p /security && \
    openssl rand -base64 756 > /security/keyfile && \
    chmod 400 /security/keyfile && \
    chown mongodb:mongodb /security/keyfile

COPY entrypoint.sh healthcheck.sh /
RUN chmod +x /entrypoint.sh /healthcheck.sh

HEALTHCHECK --interval=15s --timeout=5s --start-period=30s --retries=3 \
	CMD /healthcheck.sh

ENTRYPOINT ["/entrypoint.sh"]
