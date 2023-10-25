import socket
import threading
from typing import Optional
from database import Database
from user import User

def handle_client(conn: socket, addr: str):
	user = None


def main():
	PORT = 5050
	SERVER = socket.gethostbyname(socket.gethostname())
	print(f"Starting server {SERVER} on port {PORT}")
	server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	server.bind((SERVER, PORT))
	server.listen()
	while True:
		conn, addr = server.accept()
		thread = threading.Thread(target=handle_client, args=(conn, addr))
		thread.start()
		print(f"Connected to {conn}:{addr}")


if __name__ == "__main__":
	database = Database("database.db")
	with open("3_100.jpg","rb") as f:
		data = f.read()
	id = database.insert_image(1,data)
	
	new_image = database.get_image(id)
	with open("asd.jpg", "wb") as f:
		f.write(new_image[2])