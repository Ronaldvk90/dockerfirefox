FROM opensuse/leap:15.6

# Install the nescesarry packages
RUN zypper update -y
RUN zypper --non-interactive install xrdp fluxbox xterm vim openssh-server wget curl cabextract firefox

# Prepare the files
COPY run.sh /.run.sh
RUN chmod +x /.run.sh

# Finaly. run the server!
ENTRYPOINT /.run.sh
