FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0 AS builder
WORKDIR /app
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN apt-get update && apt install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# Add this to suppress the hardlink warning
ENV UV_LINK_MODE=copy

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-install-project --no-dev

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0 AS runner
ENV WORKDIR="/app"
ENV PATH="${WORKDIR}/.venv/bin:${PATH}"
# Ensure uv and the shell agree on the link mode
ENV UV_LINK_MODE=copy
WORKDIR ${WORKDIR}
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY --from=builder "${WORKDIR}/.venv" "${WORKDIR}/.venv"