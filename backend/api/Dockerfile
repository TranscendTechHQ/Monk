FROM python:3.11-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /backend

COPY . .

RUN uv venv 
ENV PATH="/backend/.venv/bin:$PATH"
RUN uv pip install --no-cache-dir -r requirements.txt 
RUN rm -rf /root/.cache

CMD ["python3", "main.py"]
