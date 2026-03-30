FROM ubuntu:24.04

ARG GHOSTTY_VERSION=1.3.1
ARG ZIG_VERSION=0.15.2
ARG GTK4_LAYER_SHELL_VERSION=1.3.0

# Build tools + Ghostty runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgtk-4-dev \
    libadwaita-1-dev \
    libwayland-dev \
    gettext \
    libxml2-utils \
    curl \
    xz-utils \
    ca-certificates \
    meson \
    ninja-build \
    pkg-config \
    gobject-introspection \
    libgirepository1.0-dev \
    && rm -rf /var/lib/apt/lists/*

# Build gtk4-layer-shell from source (not packaged in Ubuntu 24.04)
RUN curl -fsSL \
        "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v${GTK4_LAYER_SHELL_VERSION}.tar.gz" \
        -o /tmp/gtk4-layer-shell.tar.gz \
    && mkdir -p /tmp/gtk4-layer-shell \
    && tar -xf /tmp/gtk4-layer-shell.tar.gz -C /tmp/gtk4-layer-shell --strip-components=1 \
    && rm /tmp/gtk4-layer-shell.tar.gz \
    && meson setup /tmp/gtk4-layer-shell/build /tmp/gtk4-layer-shell \
        -Dexamples=false \
        -Ddocs=false \
        -Dvapi=false \
        --prefix=/usr \
    && ninja -C /tmp/gtk4-layer-shell/build install \
    && rm -rf /tmp/gtk4-layer-shell

# Install Zig
RUN curl -fsSL "https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz" \
        -o /tmp/zig.tar.xz \
    && tar -xf /tmp/zig.tar.xz -C /opt \
    && mv "/opt/zig-x86_64-linux-${ZIG_VERSION}" /opt/zig \
    && rm /tmp/zig.tar.xz

ENV PATH="/opt/zig:$PATH"

# Download Ghostty source
RUN curl -fsSL "https://release.files.ghostty.org/${GHOSTTY_VERSION}/ghostty-source.tar.gz" \
        -o /tmp/ghostty-source.tar.gz \
    && mkdir -p /build \
    && tar -xf /tmp/ghostty-source.tar.gz -C /build --strip-components=1 \
    && rm /tmp/ghostty-source.tar.gz

WORKDIR /build

# Build — artifacts land in /build/zig-out/
RUN zig build -Doptimize=ReleaseFast

# Stage gtk4-layer-shell libs next to the Ghostty artifacts for easy extraction
RUN find /usr/lib -name 'libgtk4-layer-shell.so*' -exec cp -P {} /build/zig-out/lib/ \;
