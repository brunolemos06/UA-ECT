FROM python:3.10.6

RUN mkdir /auth_backend
RUN mkdir /auth_backend/volumes
# Set the working directory inside the container
WORKDIR /auth_backend

# Copy requirements file
COPY requirements.txt .
# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy rest of flask auth app
COPY app.py app.py
COPY clean_db.py clean_db.py
COPY client_secret_google.json client_secret_google.json
COPY sqlite_setup.py sqlite_setup.py
COPY user.py user.py
COPY users.db users.db

# Expose port (still to decide)
EXPOSE 5100

VOLUME /auth_backend/volumes

# Define startup command
CMD ["python3", "app.py"]


