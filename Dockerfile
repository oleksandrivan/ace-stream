ARG UBUNTU_IMAGE=ubuntu:bionic

FROM $UBUNTU_IMAGE

ARG ACESTREAM_LINK=https://download.acestream.media/linux/acestream_3.1.75rc4_ubuntu_18.04_x86_64_py3.8.tar.gz

# Install and update needed packages
RUN set -ex && \
    apt-get update && \
    apt-get install -yq \
        wget \
        python3.8 \
        sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/*


#Install Ace Strem
RUN mkdir -p /opt/acestream && \
    wget --output-document acestream.tar.gz $ACESTREAM_LINK && \
    tar -C /opt/acestream -xzvf acestream.tar.gz && \
    rm acestream.tar.gz

# Install Ace Stream dependencies
RUN cd /opt/acestream && \
    ./install_dependencies.sh

# Fix locale Python issue : https://stackoverflow.com/a/58173981
ENV LANG C.UTF-8

# Start Ace Stream
RUN /opt/acestream/start-engine --version



# /opt/acestream/start-engine --allow-user-config --bind-all --client-console
ENTRYPOINT ["/opt/acestream/start-engine", "--allow-user-config", "--bind-all", "--client-console"]
HEALTHCHECK CMD wget -q -t1 -O- 'http://127.0.0.1:6878/webui/api/service?method=get_version' | grep '"error": null'
# Port for HTTP
EXPOSE 6878
# Port for exposing stream
EXPOSE 8621


