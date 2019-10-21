#!/usr/bin/env python3

import os
import socket
import threading


def receive():
    while True:
        msg = client_socket.recv(BUFSIZ).decode("utf8")
        if msg == "{quit}":
            client_socket.close()
            break
        if not msg:
            break
        print(msg)


def send():
    while True:
        msg = input()
        client_socket.send(bytes(msg, "utf8"))
        if msg == "{quit}":
            break


CHAT_SERVER_HOST = os.getenv("CHAT_SERVER_HOST", "127.0.0.1")
CHAT_SERVER_PORT = os.getenv("CHAT_SERVER_PORT", 1119)

print(
    "Connecting to chat server at {HOST}:{PORT}".format(
        HOST=CHAT_SERVER_HOST, PORT=CHAT_SERVER_PORT
    )
)

BUFSIZ = 1024
ADDR = (CHAT_SERVER_HOST, int(CHAT_SERVER_PORT))

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(ADDR)

receive_thread = threading.Thread(target=receive)
send_thread = threading.Thread(target=send)
receive_thread.start()
send_thread.start()
receive_thread.join()
send_thread.join()
