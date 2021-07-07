FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    apt install -y locales git curl wget python3-pip python3-dev build-essential unzip

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install -U pip

ARG PB_REL="https://github.com/protocolbuffers/protobuf/releases"
ARG PB_VER="3.17.3"
RUN wget ${PB_REL}/download/v${PB_VER}/protoc-${PB_VER}-linux-x86_64.zip && \
    unzip protoc-${PB_VER}-linux-x86_64.zip -d /usr/local && \
    chmod +x /usr/local/bin/protoc && rm protoc-${PB_VER}-linux-x86_64.zip

# RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protobuf-all-3.17.3.tar.gz && \
#     tar -xzf protobuf-all-3.17.3.tar.gz && cd protobuf-3.17.3/ && ./configure --prefix=/usr && make && make install && \
#     cd .. && rm protobuf-all-3.17.3.tar.gz && rm -rf protobuf-3.17.3

RUN pip install poetry

# # Get set up with the virtual env & dependencies
# RUN poetry run pip install --upgrade pip
# RUN poetry install

# # Activate the poetry environment
# RUN poetry shell

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN groupmod --gid $USER_GID $USERNAME \
    && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME