FROM ubuntu:22.04

LABEL description="APEX sparse-GRM trans-xQTL pipeline"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        tabix \
        bcftools \
        zlib1g \
        libbz2-1.0 \
        liblzma5 \
        libcurl4 \
        libssl3 \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/corbinq/apex.git /opt/apex && \
    gunzip /opt/apex/bin/apex_Linux_x86_64.gz && \
    mv /opt/apex/bin/apex_Linux_x86_64 /usr/local/bin/apex && \
    chmod +x /usr/local/bin/apex && \
    apex --help

RUN mkdir -p /pipeline
COPY run_apex_trans.sh /pipeline/run_apex_trans.sh
RUN chmod +x /pipeline/run_apex_trans.sh

WORKDIR /pipeline
