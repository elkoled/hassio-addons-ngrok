ARG BUILD_FROM=homeassistant/amd64-base:latest
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /

# Setup requirements
ARG BUILD_ARCH
RUN set -x \
    && echo "BUILD_ARCH is set to: ${BUILD_ARCH}" \
    && apk add --no-cache curl tar \
    && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
    && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="amd64"; fi \
    && if [[ "${BUILD_ARCH}" = "armhf" ]]; then ARCH="arm"; fi \
    && if [[ "${BUILD_ARCH}" = "armv7" ]]; then ARCH="arm"; fi \
    && if [[ "${BUILD_ARCH}" = "i386" ]]; then ARCH="386"; fi \
    && if [[ -z "${ARCH}" ]]; then ARCH="amd64"; fi \
    && echo "ARCH is set to: ${ARCH}" \
    && if [[ "${ARCH}" = "amd64" ]]; then \
        curl -Lo /ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz; \
    else \
        echo "Unsupported architecture: ${ARCH}"; exit 1; \
    fi \
    && tar -xzf /ngrok.tgz -C /usr/local/bin \
    && rm -f /ngrok.tgz

# Initialize ngrok
RUN ngrok --version
