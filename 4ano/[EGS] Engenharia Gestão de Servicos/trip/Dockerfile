FROM python:3.10.6

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
RUN mkdir /maps_api
RUN mkdir /maps_api/volumes

WORKDIR /maps_api

# Copy requirements file
COPY requirements.txt requirements.txt

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

#Copy rest of payments app
COPY maps_api/. .

# Expose port (still to decide)
EXPOSE 5015

VOLUME /maps_api/volumes


RUN python3 manage.py makemigrations && python3 manage.py migrate

# # Run django makemigrations
# CMD ["python3", "manage.py", "makemigrations"]

# # Run django migrate
# CMD ["python3", "manage.py", "migrate"]

# Run django runserver
CMD ["python3", "manage.py", "runserver", "0.0.0.0:5015"] 

#BUILD IMAGE
# docker build -t my-django-app .
#RUN CONTAINER
# docker run -d -p 127.0.0.1:5015:5015 my-django-app
