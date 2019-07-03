FROM ubuntu:16.04

ENV BUILD_PACKAGES git yarn wget bash make gcc g++ gnupg ca-certificates software-properties-common build-essential \
                    python3.6 python3.6-dev python3-pip python3.6-venv python3 nginx tmux python3-zmq lynx htop \
                    openssh-client jq
ENV NPM_PACKAGES wait-port ts-node tslint typescript

ENV NAME test
ENV EMAIL test@particl.xyz
ENV COMMENT comment
ENV PASSPHRASE changeme
ENV NETWORK testnet

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NVM $NVM_DIR/nvm.sh
ENV NODE_VERSION v11.13.0
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/
ENV PARTICL_BIN /root/particl-binaries
ENV PATH $PARTICL_BIN:$NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

RUN rm /bin/sh \
        && ln -s /bin/bash /bin/sh
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update \
        && apt-get install -y software-properties-common curl apt-transport-https \
        && add-apt-repository ppa:jonathonf/python-3.6
#        && add-apt-repository ppa:jonathonf/python-2.7

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
        && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -y \
        && apt-get install -y $BUILD_PACKAGES \
        && rm -rf /var/lib/apt/lists/*

#RUN ln -s /usr/bin/python2.7 /usr/bin/python

RUN mkdir -p $NVM_DIR
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# confirm installation of node
RUN node -v
RUN npm -v
RUN yarn -v

# update pip
RUN python3.6 -m pip install pip --upgrade && \
        python3.6 -m pip install wheel


RUN mkdir -p /app/data
WORKDIR /app
COPY package.json /app

RUN npm install
COPY . /app

CMD [ "npm", "start" ]
EXPOSE 3000
