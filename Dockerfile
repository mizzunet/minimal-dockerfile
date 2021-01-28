FROM python:3.7-slim
# install the notebook package
USER root
RUN passwd -d root&& passwd -d $NB_USER
RUN apt-get update -y &&apt-get install sudo -y
