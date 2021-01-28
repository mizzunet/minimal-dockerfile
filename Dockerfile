FROM python:3.7-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook
USER root
# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}
# install the notebook package
USER root
RUN passwd -d root&&passwd -d ${NB_USER}
COPY sudoers .
RUN passwd -d root&&mv ./sudoers /etc/sudoers&&passwd -d $NB_USER

RUN apt-get update -y &&apt-get install sudo -y
