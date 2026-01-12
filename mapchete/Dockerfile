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
RUN mkdir -p deps && \
    git clone --depth 1 --branch ${REPO_CORE_REF} https://github.com/mapchete/mapchete deps/mapchete && \
    git clone --depth 1 --branch ${REPO_EO_REF} https://github.com/mapchete/mapchete-eo deps/mapchete-eo && \
    git clone --depth 1 --branch ${REPO_HUB_REF} https://github.com/mapchete/mapchete-hub deps/mapchete-hub

RUN uv init --name factory-build --lib . && \
    uv add ./deps/mapchete ./deps/mapchete-eo ./deps/mapchete-hub && \
    uv lock && \
    uv sync --frozen --no-dev

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0

ENV WORKDIR="/app"
ENV GML_SKIP_CORRUPTED_FEATURES=YES
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_NO_CACHE=YES

WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/deps /app/deps
COPY . .
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV PATH="/app/.venv/bin:$PATH"

CMD ["mapchete", "--help"]