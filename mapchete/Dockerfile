FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0 AS builder
WORKDIR /app
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

# Copy the dynamically generated lockfile and pyproject
COPY pyproject.toml uv.lock ./

# Install into the venv using the lockfile
RUN uv sync --frozen --no-install-project

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0 AS runner
WORKDIR /app
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/
COPY --from=builder /app/.venv /app/.venv
ENV PATH="/app/.venv/bin:$PATH"