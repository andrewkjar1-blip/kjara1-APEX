FROM ubuntu:22.04

LABEL description="APEX sparse-GRM trans-xQTL pipeline"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        wget \
        ca-certificates \
        tabix \
        bcftools \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libboost-math-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/corbinq/apex.git /opt/apex && \
    cd /opt/apex && \
    bash get_dependencies.sh && \
    make && \
    cp /opt/apex/bin/apex /usr/local/bin/apex && \
    chmod +x /usr/local/bin/apex

RUN mkdir -p /pipeline
COPY scripts/run_apex_trans.sh /pipeline/run_apex_trans.sh
RUN chmod +x /pipeline/run_apex_trans.sh

WORKDIR /pipeline
