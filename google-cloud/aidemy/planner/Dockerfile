FROM python:3.12-slim-bullseye

WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --trusted-host pypi.python.org --no-cache-dir -r requirements.txt

# Copy source 
COPY src/ ./src/
COPY setup/ ./setup/

EXPOSE 8080
# Run the application
ENTRYPOINT ["python", "src/app.py"]