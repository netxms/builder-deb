ARG BASE_IMAGE=debian:trixie
FROM ${BASE_IMAGE}

ARG DISTRO_TYPE
ARG DISTRO_VERSION

# Oracle Instant Client (arch-specific)
COPY files/instantclient_*.tar.bz2 /tmp/
RUN set -ex && \
    apt-get update && apt-get install -y --no-install-recommends bzip2 && \
    ARCH=$(dpkg --print-architecture) && \
    tar jxf /tmp/instantclient_${ARCH}.tar.bz2 -C /opt && \
    rm -f /tmp/instantclient_*.tar.bz2 && \
    apt-get purge -y bzip2 && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Maven
COPY files/apache-maven-3.9.14-bin.tar.gz /tmp/
RUN tar xzf /tmp/apache-maven-3.9.14-bin.tar.gz -C /opt && \
    rm /tmp/apache-maven-3.9.14-bin.tar.gz
ENV PATH="/opt/apache-maven-3.9.14/bin:${PATH}"

# APT setup + build deps
RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg && \
    install -d /etc/apt/keyrings && \
    curl -fsSL "https://packages.netxms.org/netxms-keyring.gpg" \
        -o /etc/apt/keyrings/netxms.gpg && \
    printf 'deb [signed-by=/etc/apt/keyrings/netxms.gpg] https://packages.netxms.org/%s/ %s main\ndeb [signed-by=/etc/apt/keyrings/netxms.gpg] https://packages.netxms.org/devel/%s/ %s main\n' \
        "$DISTRO_TYPE" "$DISTRO_VERSION" "$DISTRO_TYPE" "$DISTRO_VERSION" \
        > /etc/apt/sources.list.d/netxms.list && \
    apt-get update && \
    JAVA_PKG=$(if apt-cache show openjdk-21-jdk-headless 2>/dev/null | grep -q '^Package:'; then \
        echo openjdk-21-jdk-headless; \
    elif apt-cache show openjdk-17-jdk-headless 2>/dev/null | grep -q '^Package:'; then \
        echo openjdk-17-jdk-headless; \
    else \
        echo openjdk-11-jdk-headless; \
    fi) && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        dpkg-dev debhelper devscripts build-essential equivs \
        flex bison lsb-release \
        chrpath perl lintian fakeroot python3 python3-debian $JAVA_PKG && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
