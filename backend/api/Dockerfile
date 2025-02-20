FROM python:3.11-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /backend

COPY . .

RUN uv sync 
ENV PATH="/backend/.venv/bin:$PATH"

CMD ["uv", "run", "main.py"]
