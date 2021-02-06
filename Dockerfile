FROM python:3.7.6-slim-buster
RUN apt-get update && apt-get install -y gnupg && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com A3A48C4A && \
    echo "deb http://ppa.launchpad.net/zeehio/festcat/ubuntu bionic main" >> /etc/apt/sources.list && \
    echo "deb-src http://ppa.launchpad.net/zeehio/festcat/ubuntu bionic main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install festival festvox-ca-ona-hts festvox-ca-pau-hts lame \
    && apt-get -y autoremove \
    && apt-get clean

ENV PORT 8100

RUN mkdir -p /srv

COPY Pipfile /srv/
COPY *.py /srv/
COPY *.txt /srv/
COPY ./tests /srv/tests

WORKDIR /srv

RUN pip install --no-cache-dir pipenv
RUN pipenv install

EXPOSE $PORT
ENTRYPOINT pipenv run gunicorn tts-service:app -b 0.0.0.0:$PORT
