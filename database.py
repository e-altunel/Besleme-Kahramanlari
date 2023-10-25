import sqlite3
import threading
import bcrypt
from user import User
from typing import Optional

class Database:
	def __init__(self, database_name: str) -> None:
		self.conection = sqlite3.connect(database_name)
		self.lock = threading.Lock()
		self.create_tables()
	
	def __del__(self):
		self.conection.close()
	
	def create_tables(self):
		self.lock.acquire()
		cursor = self.conection.cursor()
		cursor.execute("""CREATE TABLE IF NOT EXISTS users (
				 id INTEGER PRIMARY KEY AUTOINCREMENT, 
				 name TEXT, 
				 email TEXT, 
				 password TEXT,
				 authorization INTEGER,
				 UNIQUE(name, email))""")
		cursor.execute("""CREATE TABLE IF NOT EXISTS images (
				 id INTEGER PRIMARY KEY AUTOINCREMENT, 
				 name TEXT,
				 user_id INTEGER,
				 image_data BLOB)""")
		self.conection.commit()
		self.lock.release()
	
	def insert_user(self, name: str, email: str, password: str, authorization: int):
		self.lock.acquire()
		cursor = self.conection.cursor()
		return_value = False
		try:
			print("Inserting user...")
			cursor.execute("""INSERT INTO users VALUES (NULL, ?, ?, ?, ?)""", 
				 (name, email, bcrypt.hashpw(password.encode(), bcrypt.gensalt()), authorization))
			print("User inserted.")
			self.conection.commit()
			return_value = True
		except Exception as e:
			print(e)
			return_value = False
		finally:
			self.lock.release()
			return return_value
	
	def get_user(self, username:str, password:str) -> Optional[User]:
		self.lock.acquire()
		cursor = self.conection.cursor()
		cursor.execute("""SELECT * FROM users WHERE name=?""", 
				 (username,))
		row: tuple = cursor.fetchone()
		if bcrypt.checkpw(password.encode(), row[3]):
			user = User(row[1], row[2], row[4])
		else:
			user = None
		self.lock.release()
		return user
