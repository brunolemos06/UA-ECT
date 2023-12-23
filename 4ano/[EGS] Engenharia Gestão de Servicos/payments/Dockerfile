FROM python:3.10.6

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
RUN mkdir /payments
RUN mkdir /payments/volumes

WORKDIR /payments

# Copy requirements file
COPY requirements.txt requirements.txt

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

#Copy rest of payments app
COPY payments/. .

# Expose port (still to decide)
EXPOSE 8000

VOLUME /payments/volumes

RUN python3 manage.py makemigrations && python3 manage.py migrate

# # Run django makemigrations
# CMD ["python3", "manage.py", "makemigrations"]

# # Run django migrate
# CMD ["python3", "manage.py", "migrate"]

# Run django runserver
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"] 



#BUILD IMAGE
# docker build -t my-django-app .
#RUN CONTAINER
# docker run -d -p 127.0.0.1:8000:8000 my-django-app

