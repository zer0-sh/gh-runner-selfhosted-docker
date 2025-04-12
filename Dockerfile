FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=America/Bogota
RUN apt-get update && apt-get install -y tzdata

RUN apt-get update && \
    apt-get install -y curl jq git sudo ca-certificates && \
    apt-get clean \
    ./bin/installdependencies.sh || true

# Crea el usuario configurable vía ARG/ENV
ARG RUNNER_USER
ENV RUNNER_USER=${RUNNER_USER:-runneruser}

RUN useradd -m -s /bin/bash $RUNNER_USER && \
    echo "$RUNNER_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/${RUNNER_USER}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Ejecuta como usuario no root
USER $RUNNER_USER

ENTRYPOINT ["/entrypoint.sh"]
