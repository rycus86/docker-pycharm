FROM --platform=${TARGETPLATFORM} debian

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

RUN apt-get update && apt-get install --no-install-recommends -y \
  python3 python3-dev python3-setuptools python3-pip \
  gcc git openssh-client less curl \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash developer

ARG TARGETARCH
ARG PYCHARM_VERSION=2023.1
ARG PYCHARM_BUILD=2023.1.2
ARG pycharm_local_dir=.PyCharmCE${PYCHARM_VERSION}

WORKDIR /opt/pycharm

RUN echo "Preparing PyCharm ${PYCHARM_BUILD} ..." \
  && if [ "$TARGETARCH" = "arm64" ]; then export pycharm_arch='-aarch64'; else export pycharm_arch=''; fi \
  && export pycharm_source=https://download.jetbrains.com/python/pycharm-community-${PYCHARM_BUILD}${pycharm_arch}.tar.gz \
  && echo "Downloading ${pycharm_source} ..." \
  && curl -fsSL $pycharm_source -o /opt/pycharm/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

USER developer
ENV HOME /home/developer

RUN mkdir /home/developer/.PyCharm \
  && ln -sf /home/developer/.PyCharm /home/developer/$pycharm_local_dir \
  && ln -sfT $(cd /usr/local/lib/python* && pwd) /home/developer/.py3.libs

CMD [ "/opt/pycharm/bin/pycharm.sh" ]
