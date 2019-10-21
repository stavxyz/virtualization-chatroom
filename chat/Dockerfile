FROM python:3.7.3

# This sets the working directory of the container instance.
WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copies current working directory into WORKDIR
# A runtime alternative is to use --volume
COPY . .

CMD [ "python", "./chat_server.py" ]
