FROM ubuntu:16.04

ENV T_UID=1000
ENV T_GID=1000
ENV COMPILE_THREADS=8
ENV NODE_VER=8.11.3

RUN apt-get update && apt-get install -y build-essential git curl python2.7 python
RUN groupadd -g $T_GID nodejs
RUN useradd -d /home/nodejs -u $T_UID -g $T_GID -s /bin/bash nodejs
RUN mkdir /home/nodejs
RUN chown -R nodejs:nodejs /home/nodejs

USER nodejs

RUN mkdir /home/nodejs/local

RUN cd /home/nodejs && git clone git://github.com/nodejs/node.git
RUN cd /home/nodejs/node \
    && git checkout v$NODE_VER \
    && ./configure --prefix=/home/nodejs/local \
    && make -j$COMPILE_THREADS \
    && make install

#RUN PATH=$PATH:/home/nodejs/local/bin && mkdir /home/nodejs/npm && cd /home/nodejs/npm && curl -L https://www.npmjs.com/install.sh | sh
RUN PATH=$PATH:/home/nodejs/local/bin && mkdir /home/nodejs/npm && cd /home/nodejs/npm && npm install npm@latest -g

RUN echo "PATH=$PATH:/home/nodejs/local/bin" > /home/nodejs/.bashrc

CMD ["/bin/bash"]
