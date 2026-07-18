FROM jenkins/jenkins:lts-jdk21

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl docker.io git golang-go \
    && rm -rf /var/lib/apt/lists/*

USER jenkins

RUN jenkins-plugin-cli --plugins \
    configuration-as-code \
    credentials-binding \
    git \
    job-dsl \
    pipeline-stage-view \
    workflow-aggregator

