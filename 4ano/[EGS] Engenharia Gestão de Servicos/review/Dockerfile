# Use an official Python runtime as the base image
FROM python:3.7.3-slim

RUN mkdir /review
RUN mkdir /review/volumes
WORKDIR /review

# Copy the requirements file to the container
COPY requirements.txt requirements.txt
# Install the Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

COPY createdb.py createdb.py
COPY database.db database.db
COPY main.py main.py
COPY static static

# Expose port 5005 to the outside world
EXPOSE 5005

VOLUME /review/volumes

# Run the Flask application
CMD ["python3", "main.py"]