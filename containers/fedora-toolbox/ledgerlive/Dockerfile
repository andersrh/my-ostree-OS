FROM ghcr.io/andersrh/containers/fedora-toolbox/base-gui:main

WORKDIR /app

RUN wget https://download.live.ledger.com/latest/linux -O ledgerlive \
&& chmod +x ledgerlive
COPY ledgerlive.desktop /usr/share/applications/
COPY ledgerlive.png /usr/share/icons/
RUN ln -s /app/ledgerlive /usr/bin/ledgerlive
