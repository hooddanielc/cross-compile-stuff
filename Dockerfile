FROM debian
RUN apt update
RUN apt full-upgrade -y
RUN apt install -y build-essential libncurses5-dev
RUN apt install -y automake libtool bison flex texinfo
RUN apt install -y gawk curl cvs subversion gcj-jdk
RUN apt install -y libexpat1-dev python-dev
RUN apt install -y git
RUN cd $HOME && git clone --branch 1.22 https://github.com/crosstool-ng/crosstool-ng.git
RUN cd $HOME/crosstool-ng && autoconf
RUN apt install -y gperf
RUN apt install -y wget
RUN apt install -y help2man
RUN apt install -y libtool-bin
RUN cd $HOME/crosstool-ng && ./configure
RUN cd $HOME/crosstool-ng && make
RUN cd $HOME/crosstool-ng && make install

# create developer user
RUN useradd -ms /bin/bash developer
USER developer
RUN mkdir $HOME/armv7l
RUN cd $HOME/armv7l && ct-ng armv7-rpi2-linux-gnueabihf
RUN cd $HOME/armv7l && ct-ng build
ENV PATH $PATH:/home/developer/x-tools/armv7-rpi2-linux-gnueabihf/bin
RUN mkdir /home/developer/src

# install ib
RUN cd $HOME && wget https://github.com/JasonL9000/ib/archive/0.7.tar.gz
RUN cd $HOME && tar -xvf 0.7.tar.gz
ENV PATH $PATH:/home/developer/ib-0.7

RUN echo "echo ===========" >> $HOME/.bashrc
RUN echo "echo \"  Welcome\"" >> $HOME/.bashrc
RUN echo "echo ===========" >> $HOME/.bashrc
RUN echo "echo \"\"" >> $HOME/.bashrc
RUN echo "cd $HOME/src" >> $HOME/.bashrc
RUN echo "echo \"USE: \\\`ib hello --out_root out\\\`\"" >> $HOME/.bashrc
RUN echo "echo \"\"" >> $HOME/.bashrc
