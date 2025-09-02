FROM ghcr.io/snakepacker/python/3.13 AS builder

ENV WORKDIR="/home"
ENV PATH="${WORKDIR}/.venv/bin:${PATH}"
WORKDIR ${WORKDIR}

# install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# install system requirements and create virtual environment
RUN apt update \
    && apt install -y --no-install-recommends \
        git \
    && rm -rf /var/lib/apt/lists/*
RUN uv venv --no-managed-python ${WORKDIR}/.venv

# install python requirements into virtual environment
COPY requirements.in .
RUN uv pip compile requirements.in -o requirements.txt \
    && uv pip sync requirements.txt \
    && rm requirements.*


FROM ghcr.io/snakepacker/python/3.13 AS runner

ENV WORKDIR="/home"
ENV PATH="${WORKDIR}/.venv/bin:${PATH}"
WORKDIR ${WORKDIR}

# copy venv from builder
COPY --from=builder "${WORKDIR}/.venv" "${WORKDIR}/.venv"

ENTRYPOINT [ "mhub" ]
