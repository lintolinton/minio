FROM clintonkavai/rflow-alpine:3.15 as builder
WORKDIR /root
RUN wget https://dl.min.io/server/minio/release/linux-amd64/minio && \
	sha256sum /root/minio > /root/minio.sha256sum && \
	apk add curl

FROM clintonkavai/rflow-alpine:3.15
ENV PATH=/opt/bin:$PATH
RUN mkdir -p /opt/bin
COPY --from=builder /root/minio /opt/bin
COPY --from=builder /root/minio.sha256sum /opt/bin/minio.sha256sum
COPY dockerscripts /usr/bin
RUN chmod +x /usr/bin/docker-entrypoint.sh /usr/bin/verify-minio.sh /opt/bin/minio
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
VOLUME ["/data"]
CMD ["minio"]


