FROM ubuntu:24.04

ARG JAVA_VER=1.8.0
ARG RUNNER=local

ENV DEBIAN_FRONTEND=noninteractive

# 修正中文显示
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# 添加maven
ENV PATH=/opt/apache-maven-3.6.3/bin:$PATH
ADD maven/apache-maven-3.6.3-bin.tar.gz /opt

RUN if [ "${RUNNER}" != "github" ]; then \
        sed -i -E 's/(archive|security|ports).ubuntu.(org|com)/mirrors.aliyun.com/g' /etc/apt/sources.list; \
        sed -i -E 's/(archive|security|ports).ubuntu.(org|com)/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources; \
    fi \    
    && apt-get update && apt-get upgrade -y  \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        locales \
        tzdata \
        software-properties-common \
        gnupg \
        wget \
        git \ 
    && locale-gen en_US.UTF-8  \
    && wget -O- https://apt.corretto.aws/corretto.key | apt-key add -  \
    && add-apt-repository 'deb https://apt.corretto.aws stable main' \
    && apt-get install -y java-$JAVA_VER-amazon-corretto-jdk  \
    && rm -rf /var/lib/apt/lists/*