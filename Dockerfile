FROM ubuntu:trusty
MAINTAINER Roberts JG <robertsjg@email.com>

# prevent dpkg errors
ENV TERM=xterm-256color

# install ubuntu python runtime os pkg
RUN apt-get update && \
    apt-get install -qy \
    -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
    python python-virtualenv libpython2.7 python-mysqldb

# Create python virtual env
# Upgrade PIP to latest version
# see hynek.me/articles/virtualenv-lives for more info on why 
# . operator reqd as source not available on bourne shell
RUN virtualenv /appenv && \
    . /appenv/bin/activate && \
    pip install pip --upgrade

# Add entrypoint script to avoid issue with pid 1 and sigterm (stop)
# resulting in sigkill after 10 seconds on docker stop - app can't then exit gracefully
ADD scripts/pythonentrypoint.sh /usr/local/bin/pythonentrypoint.sh
RUN chmod +x /usr/local/bin/pythonentrypoint.sh
ENTRYPOINT ["pythonentrypoint.sh"]

LABEL application=todobackend

