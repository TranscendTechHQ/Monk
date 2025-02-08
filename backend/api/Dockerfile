FROM python:3.11-slim


WORKDIR /backend

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt && \
    rm -rf /root/.cache

CMD ["python3", "main.py"]
