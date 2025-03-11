FROM python:3.11-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /backend

RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY pyproject.toml uv.lock ./

RUN uv sync --frozen

COPY . .

ENV PATH="/backend/.venv/bin:$PATH"

CMD ["uv", "run", "main.py"]
