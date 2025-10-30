FROM almalinux:8

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
    rpm-build \
    curl \
    && dnf clean all

# Create workspace directory
RUN mkdir -p /mnt/workspace

# Create a non-root user (e.g., 'builder')
ARG DOCKER_MYUID
ARG DOCKER_MYGID
RUN groupadd -g $DOCKER_MYGID builder \
    && useradd -m -s /bin/bash -u $DOCKER_MYUID -g $DOCKER_MYGID builder

# Set the working directory to the user's home
WORKDIR /home/builder

# Change ownership of the working directory to the new user
RUN chown -R builder:builder /home/builder

# Change ownership of the extenral mount
RUN chown -R builder:builder /mnt/workspace

# Switch to the non-root user
USER builder

# 2. Install nvm (Node Version Manager)
# This installs nvm into /home/builder/.nvm
# The install script automatically adds the necessary sourcing lines to /home/builder/.bashrc
ENV NVM_DIR="/home/builder/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 3. Install Rust using rustup
# This installs rustup into /home/builder/.rustup and Rust into /home/builder/.cargo
# The installer automatically adds the sourcing line for /home/builder/.cargo/env to /home/builder/.bashrc
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 4. Consolidate and Ensure Shell Initialization
# The previous two steps should have automatically added the necessary sourcing commands
# to /home/builder/.bashrc.
# To ensure they are always sourced even for non-login, interactive shells (like 'docker exec -it ... bash'),
# we explicitly add a check/source to the user's .bashrc.
# NOTE: The default .bashrc in Ubuntu already handles sourcing correctly, but this is a fail-safe.
RUN echo '' >> /home/builder/.bashrc \
    && echo '# Load nvm' >> /home/builder/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/builder/.bashrc \
    && echo '' >> /home/builder/.bashrc \
    && echo '# Load cargo environment' >> /home/builder/.bashrc \
    && echo '[ -f "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"' >> /home/builder/.bashrc

# 5. Install node via nvm
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 22.18.0"
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 20.19.0"
RUN bash -c "source $NVM_DIR/nvm.sh && nvm alias default 22.18.0"

# Default command
CMD ["/bin/bash"]

