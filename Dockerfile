# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
RUN sudo curl -fsSL https://deb.nodesource.com/setup_15.x | sudo bash -
RUN sudo apt-get install -y nodejs
RUN sudo apt-get install -y wget
RUN sudo apt-get install -y neofetch
<<<<<<< HEAD
RUN sudo apt install -y libc6-x32 libc6-i386
RUN sudo apt-get install -y libxi6
RUN sudo apt-get install -y libasound2-dev
RUN sudo apt-get install -y libxrender1
RUN sudo apt-get install -y libxtst6
=======
RUN curl -O https://download.java.net/java/GA/jdk18/43f95e8614114aeaa8e8a5fcf20a682d/36/GPL/openjdk-18_linux-x64_bin.tar.gz
RUN tar xvf openjdk-18_linux-x64_bin.tar.gz
RUN sudo mv jdk-18 /opt/
RUN sudo tee /etc/profile.d/jdk18.sh <<EOF
export JAVA_HOME=/opt/jdk-18
export PATH=\$PATH:\$JAVA_HOME/bin
EOF


>>>>>>> 92d9f2a0e14af585f7086f21666bbe6fe95477b5

RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
RUN sudo dpkg -i jdk-17_linux-x64_bin.deb
RUN sudo apt-get install -y default-jre


# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
