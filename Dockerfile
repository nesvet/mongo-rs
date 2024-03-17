FROM mongo:latest

RUN mkdir -p /security && \
    openssl rand -base64 756 > /security/keyfile && \
    chmod 400 /security/keyfile && \
    chown mongodb:mongodb /security/keyfile

HEALTHCHECK --interval=5s --timeout=5s --start-period=10s \
    CMD mongosh --eval "db.adminCommand(\"ping\");" || exit 1

COPY --chmod=755 scripts/* /scripts/
CMD /scripts/setup