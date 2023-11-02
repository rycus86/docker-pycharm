FROM --platform=${TARGETPLATFORM} debian:bullseye-20231030

ARG TARGETARCH

LABEL maintainer="Azul Group <azul-group@ucsc.edu>"

ARG azul_docker_pycharm_version

RUN \
  apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y \
    python3 python3-dev \
    gcc git openssh-client less curl ca-certificates \
    libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
    libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/pycharm

SHELL ["/bin/bash", "-c"]

ARG PYCHARM_VERSION

RUN set -o pipefail \
  && export pycharm_arch=$(python3 -c "print(dict(amd64='',arm64='-aarch64')['${TARGETARCH}'])") \
  && export pycharm_source="https://download.jetbrains.com/python/pycharm-community-${PYCHARM_VERSION}${pycharm_arch}.tar.gz" \
  && echo "Downloading ${pycharm_source}" \
  && curl -fsSL "${pycharm_source}" -o installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

# CVE-2021-23383 CVE-2021-23369 CVE-2019-19919 GHSA-q42p-pg8m-cqh6
# GHSA-q2c6-c6pm-g3gh GHSA-g9r4-xpmj-mj65 GHSA-2cf5-4w76-r9qv CVE-2019-20920
# GHSA-h6ch-v84p-w6p9⁠ CVE-2020-7712⁠
RUN rm -rf /opt/pycharm/plugins/textmate

# CVE-2023-24539 CVE-2023-24540 CVE-2023-29400 CVE-2023-29403 CVE-2023-39325
# CVE-2023-44487 CVE-2021-21353⁠
RUN rm /opt/pycharm/bin/repair

RUN useradd -ms /bin/bash developer

USER developer
ENV HOME /home/developer

ARG pycharm_local_dir=.PyCharmCE${PYCHARM_VERSION}

RUN mkdir /home/developer/.PyCharm \
  && ln -sf /home/developer/.PyCharm "/home/developer/$pycharm_local_dir"

SHELL ["/bin/sh", "-c"]

CMD [ "/opt/pycharm/bin/pycharm.sh" ]
