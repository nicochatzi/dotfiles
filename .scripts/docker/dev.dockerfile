FROM ubuntu:24.04 as base

FROM base as dev

# install dev packages
RUN apt update && apt install -y \
  curl \
  build-essential \
  cmake \
  clang \
  just

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

