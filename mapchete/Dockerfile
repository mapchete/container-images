FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0 AS builder

ENV WORKDIR="/app"
ENV GML_SKIP_CORRUPTED_FEATURES=YES
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PATH="${WORKDIR}/.venv/bin:${PATH}"

WORKDIR ${WORKDIR}

# install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# install system requirements and create virtual environment
RUN apt-get update \
    && apt install -y --no-install-recommends \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && uv venv --no-managed-python ${WORKDIR}/.venv

# install python requirements into virtual environment
COPY requirements.in .
RUN uv pip compile requirements.in -o requirements.txt \
    && uv pip sync requirements.txt \
    && rm requirements.*

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.12.0 AS runner

ENV WORKDIR="/app"
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_NO_CACHE=YES
ENV PATH="${WORKDIR}/.venv/bin:${PATH}"

WORKDIR ${WORKDIR}

# make sure uv is available further on
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# copy venv from builder
COPY --from=builder "${WORKDIR}/.venv" "${WORKDIR}/.venv"
