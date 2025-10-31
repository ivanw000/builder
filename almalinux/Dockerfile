FROM almalinux:8

# Update system and install sudo
RUN dnf update -y && \
    dnf install -y sudo

# Install config-manager from dnf-plugins-core
RUN dnf install -y dnf-plugins-core

# Enable PowerTools repository
RUN dnf config-manager --set-enabled powertools

# Add GitHub CLI repository
RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

# Install "Development Tools" group
RUN dnf groupinstall -y "Development Tools"

# Install required packages
RUN dnf install -y \
    epel-release \
    gh \
    git \
    jq \
    python3.11 \
    libX11-devel \
    libxkbfile-devel \
    krb5-devel \
    at-spi2-atk \
    gtk3 \
    gtk3-devel \
    alsa-lib \
    gperf \
    readline-devel \
    rpm-build \
    curl \
    && dnf clean all

# Create workspace directory
RUN mkdir -p /mnt/workspace

# Create a non-root user (e.g., 'builder')
ARG USERNAME=builder
ARG DOCKER_MYUID
ARG DOCKER_MYGID
RUN groupadd -g $DOCKER_MYGID $USERNAME \
    && useradd -m -s /bin/bash -u $DOCKER_MYUID -g $DOCKER_MYGID $USERNAME

# Add user to sudoers with NOPASSWD (optional - remove NOPASSWD if you want password prompts)
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Set the working directory to the user's home
WORKDIR /home/$USERNAME

# Change ownership of the working directory to the new user
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

# Change ownership of the extenral mount
RUN chown -R $USERNAME:$USERNAME /mnt/workspace

# Switch to the non-root user
USER $USERNAME

# Update bashrc
RUN echo "alias ls='ls --color=auto -F'" >> .bashrc

# 2. Install nvm (Node Version Manager)
# This installs nvm into /home/$USERNAME/.nvm
# The install script automatically adds the necessary sourcing lines to /home/$USERNAME/.bashrc
ENV NVM_DIR="/home/$USERNAME/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 3. Install Rust using rustup
# This installs rustup into /home/$USERNAME/.rustup and Rust into /home/$USERNAME/.cargo
# The installer automatically adds the sourcing line for /home/$USERNAME/.cargo/env to /home/$USERNAME/.bashrc
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 4. Consolidate and Ensure Shell Initialization
# The previous two steps should have automatically added the necessary sourcing commands
# to /home/$USERNAME/.bashrc.
# To ensure they are always sourced even for non-login, interactive shells (like 'docker exec -it ... bash'),
# we explicitly add a check/source to the user's .bashrc.
# NOTE: The default .bashrc in Ubuntu already handles sourcing correctly, but this is a fail-safe.
RUN echo '' >> /home/$USERNAME/.bashrc \
    && echo '# Load nvm' >> /home/$USERNAME/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/$USERNAME/.bashrc \
    && echo '' >> /home/$USERNAME/.bashrc \
    && echo '# Load cargo environment' >> /home/$USERNAME/.bashrc \
    && echo '[ -f "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"' >> /home/$USERNAME/.bashrc

# 5. Install node via nvm
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 22.18.0"
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 20.19.0"
RUN bash -c "source $NVM_DIR/nvm.sh && nvm alias default 22.18.0"

# Default command
CMD ["/bin/bash"]

