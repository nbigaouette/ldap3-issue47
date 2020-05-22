FROM rust:1.43.1

RUN apt-get update
RUN apt-get install -y \
    curl \
    neovim \
    valgrind

RUN curl -s -L "https://github.com/DynamoRIO/drmemory/releases/download/release_2.3.0/DrMemory-Linux-2.3.0-1.tar.gz" | tar -zxf -
ENV PATH="/DrMemory-Linux-2.3.0-1/bin64/:${PATH}"

# RUN echo "127.0.0.1"