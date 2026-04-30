FROM texlive/texlive:latest

# Install Noto CJK fonts (Korean support for XeLaTeX)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        fonts-noto-cjk \
        fonts-noto-cjk-extra && \
    fc-cache -fv && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
