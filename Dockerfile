# 1. Use the slim Python image
FROM python:slim

# 2. Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# 3. Set the working directory
WORKDIR /app

# 4. Install system dependencies AND Google Cloud SDK
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    libgomp1 \
    ca-certificates \
    && \
    # Create keyring directory
    mkdir -p /usr/share/keyrings && \
    # Download, de-armor, and save the GCloud key
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/google-cloud.gpg && \
    # Add the GCloud source and point it to the key
    echo "deb [signed-by=/usr/share/keyrings/google-cloud.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
    # Install the SDK
    apt-get update && apt-get install -y google-cloud-sdk && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 5. Copy the application code
COPY . .

# 6. Install the package in editable mode
RUN pip install --no-cache-dir -e .

# 7. Train the model before running the application
RUN python pipeline/training_pipeline.py

# 8. Expose the port that Flask will run on
EXPOSE 5000

# 9. Command to run the app
CMD ["python", "application.py"]