# Stage 1: Build
FROM python:3.13-trixie as builder
WORKDIR /app
COPY ./requirements.txt .
RUN pip install --target="install/" -r requirements.txt

# Stage 2: Production
FROM python:3.13-slim as prod
WORKDIR /app
RUN apt update && \
    apt install -y --no-install-recommends \
      libpq-dev \
      gcc \
      libcairo2 \
      libpango-1.0-0 \
      libpangocairo-1.0-0 \
      libgdk-pixbuf-xlib-2.0-0 \
      libffi-dev \
      shared-mime-info && \
    rm -drvf /var/lib/apt/lists 
COPY --from=builder /app/install /usr/local/lib/python3.13/site-packages
COPY . .
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
