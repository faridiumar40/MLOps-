# 1. Use the slim Python image (as you had)
FROM python:slim

# 2. Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# 3. Set the working directory
WORKDIR /app

# 4. Install system dependencies AND Google Cloud SDK
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Add curl and gnupg to install GCloud
    curl \
    gnupg \
    # Add libgomp1 (from your original file)
    libgomp1 \
    && \
    # Add the Google Cloud SDK source
    echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
    # Add the GCloud key (no 'sudo' needed)
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
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