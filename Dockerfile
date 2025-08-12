FROM ghcr.io/osgeo/gdal:ubuntu-small-3.11.3 AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV GML_SKIP_CORRUPTED_FEATURES=YES
ENV BUILD_DIR="/usr/local"
ENV MHUB_DIR="${BUILD_DIR}/src/mapchete_hub"
ENV WHEEL_DIR="/usr/local/wheels"
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN apt-get update \
    && apt install -y --no-install-recommends \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN uv venv ${MHUB_DIR}/.venv
ENV PATH="/${MHUB_DIR}/.venv/bin:${PATH}"

COPY requirements.in .

# uv pip compile requirements.in -o requirements.txt
RUN uv pip compile requirements.in -o requirements.txt
RUN uv pip sync requirements.txt
RUN rm requirements.*

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.11.3 AS runner
ENV BUILD_DIR="/usr/local"
ENV MHUB_DIR="${BUILD_DIR}/src/mapchete_hub"
COPY --from=builder ${MHUB_DIR}/.venv ${MHUB_DIR}/.venv
ENV PATH="/${MHUB_DIR}/.venv/bin:${PATH}"
