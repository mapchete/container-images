FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ARG MAPCHETE_REF=main
ARG MAPCHETE_EO_REF=main
ARG MAPCHETE_HUB_REF=main

WORKDIR /app
RUN mkdir -p deps/mapchete deps/mapchete-eo deps/mapchete-hub

RUN git clone https://github.com/mapchete/mapchete deps/mapchete && \
    cd deps/mapchete && git checkout ${MAPCHETE_REF}

RUN git clone https://github.com/mapchete/mapchete-eo deps/mapchete-eo && \
    cd deps/mapchete-eo && git checkout ${MAPCHETE_EO_REF}

RUN git clone https://github.com/mapchete/mapchete-hub deps/mapchete-hub && \
    cd deps/mapchete-hub && git checkout ${MAPCHETE_HUB_REF}

RUN uv export --frozen --project deps/mapchete >> raw.txt && \
    uv export --frozen --project deps/mapchete-eo >> raw.txt && \
    uv export --frozen --project deps/mapchete-hub >> raw.txt && \
    grep '==' raw.txt | \
    grep -v "mapchete" | \
    sed 's/[[:space:];\\].*//' | sort -V | \
    awk -F'==' '{a[$1]=$2} END {for (i in a) print i"=="a[i]}' | sort > requirements.txt

RUN uv init --name factory-build --lib .

RUN MAPCHETE_SHA=$(git -C deps/mapchete rev-parse HEAD) && \
    EO_SHA=$(git -C deps/mapchete-eo rev-parse HEAD) && \
    HUB_SHA=$(git -C deps/mapchete-hub rev-parse HEAD) && \
    uv add --constraints requirements.txt \
      "mapchete[complete] @ git+https://github.com/mapchete/mapchete.git@$MAPCHETE_SHA" \
      "mapchete-eo @ git+https://github.com/mapchete/mapchete-eo.git@$EO_SHA" \
      "mapchete-hub @ git+https://github.com/mapchete/mapchete-hub.git@$HUB_SHA"

# Generate the fingerprint based on the resolved lockfile
# Combine the lockfile hash AND a hash of the source code 
# to ensure code-only changes are captured
RUN sha256sum uv.lock > /app/combined_hash && \
    # 1. Find all relevant files (py, toml, yaml)
    # 2. Exclude .git and hidden directories
    # 3. Use 'cat' to hash content only (ignoring mtime) 
    # 4. Sort to ensure identical order
    find deps/ -type f \( -name "*.py" -o -name "*.toml" -o -name "*.yaml" \) \
    -not -path '*/.*' | sort | xargs sha256sum >> /app/combined_hash && \
    # Create final fingerprint
    sha256sum /app/combined_hash | cut -d' ' -f1 > /app/uv_fingerprint


FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0

ARG IMAGE_FINGERPRINT=unknown

RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libxcb1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/deps /app/deps
COPY --from=builder /app/uv_fingerprint /app/uv_fingerprint

COPY . .

LABEL org.mapchete.image_fingerprint=$IMAGE_FINGERPRINT
LABEL org.mapchete.uv_lock_hash=$IMAGE_FINGERPRINT

ENV PATH="/app/.venv/bin:$PATH"

CMD ["mapchete", "--help"]