##dockerfile for chat_apy.py

FROM python:3.8.10

WORKDIR /chat

COPY requirements.txt .
COPY static static
COPY templates templates

EXPOSE 5010

RUN pip3 install -r requirements.txt

COPY chat.py .
COPY .env .


CMD ["python3", "chat.py"]


