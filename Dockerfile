FROM alpine

EXPOSE 3000

ENV GOPATH=/tmp/go

RUN set -ex \
    && apk add --update --no-cache bash \
    && apk add --update --no-cache --virtual .build-deps \
        rsync \
        git \
        go \
        build-base \
        tar \
        ruby \
        ruby-irb \
        ruby-dev \
        ruby-rdoc \
        rpm \
    && gem install fpm \
    && cd /tmp \
    && { go get -d github.com/github/orchestrator ; : ; } \
    && cd $GOPATH/src/github.com/github/orchestrator \
    && bash -x build.sh -t linux \
    && ls -R /tmp/orchestrator-release \
    && rsync -av $(find /tmp/orchestrator-release -type d -name orchestrator -maxdepth 2)/ / \
    && rsync -av $(find /tmp/orchestrator-release -type d -name orchestrator-cli -maxdepth 2)/ / \
    && rsync -av $(find /tmp/orchestrator-release -type f -name \*rpm -maxdepth 2) / \
    && rsync -av $(find /tmp/orchestrator-release -type f -name \*deb -maxdepth 2) / \
    && cd / \
    && apk del .build-deps \
    && rm -rf /tmp/*

WORKDIR /usr/local/orchestrator
ADD docker/entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh
