FROM python:3.7.3

# This sets the working directory of the container instance.
WORKDIR /usr/src/app

# Copies current working directory into WORKDIR
# A runtime alternative is to use --volume
COPY . .
RUN if [ -f "requirements.txt" ]; then pip install --no-cache-dir -r requirements.txt; fi

CMD [ "python", "./chat_server.py" ]
