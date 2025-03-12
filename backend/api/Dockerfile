FROM python:3.11-slim

# Copy UV package manager
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /backend

# Install system dependencies - this rarely changes
RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy only dependency files first
COPY pyproject.toml uv.lock ./

# Install Python dependencies - this layer will be cached unless dependencies change
RUN uv sync --frozen

# Copy the rest of the application code - this changes frequently
COPY . .

ENV PATH="/backend/.venv/bin:$PATH"

CMD ["uv", "run", "main.py"]
