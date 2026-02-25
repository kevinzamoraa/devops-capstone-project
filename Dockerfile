# 1. Use lightweight Python 3.9 base image
FROM python:3.9-slim

# 2. Set the working directory
WORKDIR /app

# 3. Install dependencies (Optimizing Docker cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copy the application code
COPY service/ ./service/

# 5. Security: Create non-root user and assign permissions
# This prevents an attacker from gaining full control of the system if the container is compromised.
RUN useradd --uid 1000 theia && chown -R theia /app
USER theia

# 6. Configure service execution
EXPOSE 8080
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]