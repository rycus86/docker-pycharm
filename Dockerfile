FROM --platform=${TARGETPLATFORM} debian:bullseye-20230502

ARG TARGETARCH

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"
LABEL maintainer "Azul Group <azul-group@ucsc.edu>"

ARG azul_docker_pycharm_version

RUN \
  apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y \
    python3 python3-dev python3-setuptools python3-pip \
    gcc git openssh-client less curl \
    libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
    libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash developer

ARG PYCHARM_VERSION=2022.3.3
ARG PYCHARM_BUILD=2022.3.3

ARG pycharm_local_dir=.PyCharmCE${PYCHARM_VERSION}

WORKDIR /opt/pycharm

SHELL ["/bin/bash", "-c"]

RUN set -o pipefail \
  && export pycharm_arch=$(python3 -c "print(dict(amd64='',arm64='-aarch64')['${TARGETARCH}'])") \
  && export pycharm_source="https://download.jetbrains.com/python/pycharm-community-${PYCHARM_BUILD}${pycharm_arch}.tar.gz" \
  && echo "Downloading ${pycharm_source}" \
  && curl -fsSL "${pycharm_source}" -o installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

USER developer
ENV HOME /home/developer

RUN mkdir /home/developer/.PyCharm \
  && ln -sf /home/developer/.PyCharm "/home/developer/$pycharm_local_dir"

SHELL ["/bin/sh", "-c"]

CMD [ "/opt/pycharm/bin/pycharm.sh" ]
