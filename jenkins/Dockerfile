FROM jenkins/jenkins:lts-jdk21

ARG DOCKER_CLI_VERSION=27.5.1

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl git golang-go \
    && curl --fail --silent --show-error --location \
      "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz" \
      --output /tmp/docker.tgz \
    && tar --extract --gzip --file /tmp/docker.tgz --directory /tmp \
    && install --mode 0755 /tmp/docker/docker /usr/local/bin/docker \
    && rm -rf /tmp/docker /tmp/docker.tgz \
    && rm -rf /var/lib/apt/lists/*

USER jenkins

RUN jenkins-plugin-cli --plugins \
    configuration-as-code \
    credentials-binding \
    git \
    job-dsl \
    pipeline-stage-view \
    workflow-aggregator
