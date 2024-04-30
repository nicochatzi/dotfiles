FROM nixos/nix:latest

RUN nix-channel --update
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

RUN mkdir -p /home/nico && \
  echo "export HOME=/home/nico" >> /home/nico/.profile && \
  echo "export USER=nico" >> /home/nico/.profile

ENV HOME /home/nico
ENV USER nico

WORKDIR /home/nico/cli

ENTRYPOINT ["nix", "develop"]
