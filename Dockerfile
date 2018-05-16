FROM debian

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

RUN apt-get update && apt-get install --no-install-recommends -y \
  python python-dev python-setuptools python-pip \
  python3 python3-dev python3-setuptools python3-pip \
  gcc git openssh-client \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 \
  && rm -rf /var/lib/apt/lists/*

ARG pycharm_source=https://download-cf.jetbrains.com/python/pycharm-community-2018.1.3.tar.gz
ARG pycharm_local_dir=.PyCharmCE2018.1

RUN mkdir /opt/pycharm
WORKDIR /opt/pycharm

ADD $pycharm_source /opt/pycharm/installer.tgz

RUN tar --strip-components=1 -xzf installer.tgz && rm installer.tgz

RUN /usr/bin/python2 /opt/pycharm/helpers/pydev/setup_cython.py build_ext --inplace
RUN /usr/bin/python3 /opt/pycharm/helpers/pydev/setup_cython.py build_ext --inplace

RUN useradd -ms /bin/bash developer
USER developer
ENV HOME /home/developer

RUN mkdir /home/developer/.PyCharm \
  && ln -sf /home/developer/.PyCharm /home/developer/$pycharm_local_dir

CMD [ "/opt/pycharm/bin/pycharm.sh" ]
