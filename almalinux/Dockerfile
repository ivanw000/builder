FROM almalinux:8

# Install config-manager from dnf-plugins-core
RUN dnf install -y dnf-plugins-core

# Enable PowerTools repository
RUN dnf config-manager --set-enabled powertools

# Add GitHub CLI repository
RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

# Install required packages
RUN dnf install -y \
    epel-release \
    gh \
    libX11-devel \
    libxkbfile-devel \
    krb5-devel \
    at-spi2-atk \
    gtk3 \
    gtk3-devel \
    alsa-lib \
    rpm-build \
    curl \
    gcc \
    && dnf clean all

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Create workspace directory
RUN mkdir -p /mnt/workspace

# Set working directory
WORKDIR /mnt/workspace

# Default command
CMD ["/bin/bash"]

