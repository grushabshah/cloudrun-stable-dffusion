# Use a slim base image to reduce image size
FROM python:3.12-slim

WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Set the environment variable for the port (Cloud Run sets this automatically)
ENV PORT=8080

# Expose the port
EXPOSE 8080

# Run the application using Gunicorn
CMD ["sh", "-c", "gunicorn --bind :$PORT --workers 3 --threads 2 --timeout 60 main:app"]
