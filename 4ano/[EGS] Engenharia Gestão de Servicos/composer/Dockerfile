##dockerfile for composer

FROM python:3.8.10

RUN mkdir /composer
RUN mkdir /composer/volumes

WORKDIR /composer

COPY requirements.txt requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt

COPY composer.py composer.py
COPY setup_db.py setup_db.py
COPY db_func.py db_func.py
COPY compuser.db compuser.db

EXPOSE 8080

VOLUME /composer/volumes

CMD ["python3", "composer.py"]
