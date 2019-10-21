#!/usr/bin/env python3
"""Server for multithreaded (asynchronous) chat application."""

import logging
import os
import socket
import threading


def accept_incoming_connections():
    """Sets up handling for incoming clients."""
    while True:
        client, client_address = SERVER.accept()
        print("%s:%s has connected." % client_address)
        client.send(
            bytes(
                "Welcome to bueno.networks chat! Type your name and press enter!",
                "utf8",
            )
        )
        addresses[client] = client_address
        threading.Thread(target=handle_client, args=(client,)).start()


def handle_client(client):  # Takes client socket as argument.
    """Handles a single client connection."""

    name = client.recv(BUFSIZ).decode("utf8")
    welcome = "Welcome %s! If you ever want to quit, type {quit} to exit." % name
    client.send(bytes(welcome, "utf8"))
    msg = "%s has joined the chat!" % name
    broadcast(bytes(msg, "utf8"))
    clients[client] = name

    while True:
        msg = client.recv(BUFSIZ)
        if msg != bytes("{quit}", "utf8"):
            logging.debug('CHAT LOG | [{name}] "{msg}"'.format(
                name=name, msg=msg.decode("utf-8")))
            broadcast(msg, name + ": ")
        else:
            logging.info('{name} is leaving the chat'.format(name=name))
            client.send(bytes("{quit}", "utf8"))
            client.close()
            del clients[client]
            broadcast(bytes("%s has left the chat." % name, "utf8"))
            break


def broadcast(msg, prefix=""):  # prefix is for name identification.
    """Broadcasts a message to all the clients."""

    for sock in clients:
        try:
            sock.send(bytes(prefix, "utf8") + msg)
        except BrokenPipeError as bpe:
            logging.error("Client hung up: %s" % bpe)
            raise


clients = {}
addresses = {}

logging.basicConfig(level=logging.DEBUG)

HOST = os.getenv("CHAT_SERVER_HOST", "127.0.0.1")
PORT = os.getenv("CHAT_SERVER_PORT", 1119)
BUFSIZ = 1024
ADDR = (HOST, int(PORT))

print("Running at {HOST}:{PORT}".format(HOST=HOST, PORT=PORT))
SERVER = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
SERVER.bind(ADDR)

if __name__ == "__main__":
    SERVER.listen(5)
    print("Waiting for connection...")
    ACCEPT_THREAD = threading.Thread(target=accept_incoming_connections)
    ACCEPT_THREAD.start()
    ACCEPT_THREAD.join()
    SERVER.close()
