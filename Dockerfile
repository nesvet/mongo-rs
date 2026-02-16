FROM mongo:8.2.3

RUN mkdir -p /security && \
    openssl rand -base64 756 > /security/keyfile && \
    chmod 400 /security/keyfile && \
    chown mongodb:mongodb /security/keyfile

HEALTHCHECK --interval=15s --timeout=5s --start-period=30s \
    CMD mongosh --eval "db.adminCommand({ ping: 1 });" || exit 1

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
