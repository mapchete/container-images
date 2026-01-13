FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ARG REPO_CORE_REF=main
ARG REPO_EO_REF=main
ARG REPO_HUB_REF=main

WORKDIR /app
RUN mkdir -p deps/mapchete deps/mapchete-eo deps/mapchete-hub

RUN git clone https://github.com/mapchete/mapchete deps/mapchete && \
    cd deps/mapchete && git checkout ${REPO_CORE_REF}

RUN git clone https://github.com/mapchete/mapchete-eo deps/mapchete-eo && \
    cd deps/mapchete-eo && git checkout ${REPO_EO_REF}

RUN git clone https://github.com/mapchete/mapchete-hub deps/mapchete-hub && \
    cd deps/mapchete-hub && git checkout ${REPO_HUB_REF}

RUN uv init --name factory-build --lib . && \
    uv add --editable ./deps/mapchete ./deps/mapchete-eo ./deps/mapchete-hub && \
    uv lock --upgrade && \
    uv sync --frozen --no-dev

# Generate the fingerprint based on the resolved lockfile
# Combine the lockfile hash AND a hash of the source code 
# to ensure code-only changes are captured
RUN sha256sum uv.lock > /app/combined_hash && \
    find deps/ -type f -exec sha256sum {} + | sort | sha256sum >> /app/combined_hash && \
    sha256sum /app/combined_hash | cut -d' ' -f1 > /app/uv_fingerprint


FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0

ARG IMAGE_FINGERPRINT=unknown

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/deps /app/deps
COPY --from=builder /app/uv_fingerprint /app/uv_fingerprint

COPY . .

LABEL org.mapchete.image_fingerprint=$IMAGE_FINGERPRINT
LABEL org.mapchete.uv_lock_hash=$IMAGE_FINGERPRINT

ENV PATH="/app/.venv/bin:$PATH"
ENTRYPOINT ["mhub"]

ENV PATH="/app/.venv/bin:$PATH"

CMD ["mapchete", "--help"]