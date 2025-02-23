FROM ghcr.io/linuxserver/baseimage-kasmvnc:latest

# Install latest Wine (>=10) from official WineHQ repositories
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y software-properties-common && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' && \
    apt update && \
    apt install -y --install-recommends winehq-stable winetricks

# Install .NET Framework, Mono, and fonts using winetricks
RUN winetricks -q dotnet48 corefonts

# Set environment variables for Wine and Kasm
ENV WINEPREFIX=/root/.wine
ENV DISPLAY=:0
EXPOSE 3000 8001
# Copy MetaTrader installation
COPY Metatrader /root/.wine/drive_c/Program\ Files/MetaTrader\ 5/

# Run MetaTrader automatically
CMD ["xvfb-run", "wine", "C:\\Program Files\\MetaTrader 5\\terminal64.exe", "/datapath=C:\\MT5Data"]

