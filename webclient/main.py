from flask import Flask, render_template, request, jsonify
import base64
import requests
import json
import os

app = Flask(__name__)

# Use environment variables for configuration to avoid hardcoding
SD_SERVER_URL = os.environ.get("SD_SERVER_URL")

if SD_SERVER_URL is None:
    raise ValueError("SD_SERVER_URL environment variable not set")


@app.route("/", methods=["GET", "POST"])
def index():
    generated_image = None
    error_message = None

    if request.method == "POST":
        prompt = request.form.get("prompt")

        if prompt:  # Check if prompt is not empty
            payload = prompt # Torchserve expects raw text, not JSON for this setup.
            headers = {'Content-Type': 'text/plain'} # Set appropriate content type
            try:
                response = requests.post(SD_SERVER_URL, data=payload, headers=headers, timeout=60)  # Add timeout

                if response.status_code == 200:
                    generated_image = response.text
                else:
                    error_message = f"Error: {response.status_code} - {response.text}"
                    print(error_message) # Log the error for debugging

            except requests.exceptions.RequestException as e:
                error_message = f"Error communicating with TorchServe: {e}"
                print(error_message)  # Log the error
        else:
            error_message = "Please enter a prompt."

    return render_template("index.html", generated_image=generated_image, error=error_message)



if __name__ == "__main__":
    # Do not use debug mode in production
    # Use a production-ready WSGI server like Gunicorn
    from waitress import serve
    serve(app, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))

