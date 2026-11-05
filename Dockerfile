FROM alpine:3.20

# Install xray-core (official release) + envsubst for config templating
RUN apk add --no-cache ca-certificates gettext curl unzip && \
    XRAY_VERSION=$(curl -sL https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep '"tag_name"' | cut -d'"' -f4) && \
    echo "Installing Xray ${XRAY_VERSION}" && \
    curl -sL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip" && \
    unzip -o /tmp/xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm -rf /tmp/xray.zip

WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh
COPY config.template.json /app/config.template.json
RUN chmod +x /app/entrypoint.sh

# Railway injects $PORT at runtime; UUID must be provided as env var
ENV UUID=""
CMD ["/app/entrypoint.sh"]
