FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ARG REPO_CLI_REF=main

WORKDIR /app
RUN mkdir -p deps/mapchete-hub-cli

RUN git clone https://github.com/mapchete/mapchete-hub-cli deps/mapchete-hub-cli && \
    cd deps/mapchete-hub-cli && git checkout ${REPO_CLI_REF}

RUN uv init --name factory-build --lib . && \
    uv add ./deps/mapchete-hub-cli && \
    uv lock && \
    uv sync --frozen --no-dev

# Generate the fingerprint based on the resolved lockfile
RUN sha256sum uv.lock | cut -d' ' -f1 > /app/uv_fingerprint
# Also keep the manifest for the CI sync check
RUN mkdir -p /app && \
    CLI_SHA=$(git -C deps/mapchete-hub-cli rev-parse HEAD 2>/dev/null || echo "none") && \
    echo "${CLI_SHA}" > /app/build_manifest    

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0

ARG IMAGE_FINGERPRINT=unknown

WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/deps /app/deps
COPY . .

COPY --from=builder /app/uv_fingerprint /app/uv_fingerprint
COPY --from=builder /app/build_manifest /app/build_manifest
LABEL org.mapchete.image_fingerprint=$IMAGE_FINGERPRINT

ENV PATH="/app/.venv/bin:$PATH"
ENTRYPOINT ["mhub"]