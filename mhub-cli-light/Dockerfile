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

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0

WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/deps /app/deps
COPY . .

ENV PATH="/app/.venv/bin:$PATH"
ENTRYPOINT ["mhub"]