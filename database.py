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
				 user_id INTEGER PRIMARY KEY AUTOINCREMENT, 
				 name TEXT, 
				 email TEXT, 
				 password BLOB,
				 authorization INTEGER,
				 UNIQUE(name, email))""")
		cursor.execute("""CREATE TABLE IF NOT EXISTS images (
				 image_id INTEGER PRIMARY KEY AUTOINCREMENT, 
				 user_id INTEGER,
				 image_data BLOB)""")
		self.conection.commit()
		self.lock.release()
	
	def insert_user(self, name: str, email: str, password: str, authorization: int) -> Optional[int]:
		self.lock.acquire()
		cursor = self.conection.cursor()
		return_value: Optional[int]= None
		try:
			cursor.execute("""INSERT INTO users VALUES (NULL, ?, ?, ?, ?)""", 
				 (name, email, bcrypt.hashpw(password.encode(), bcrypt.gensalt()), authorization))
			return_value = cursor.lastrowid
			self.conection.commit()
		except Exception as e:
			return_value = None
		finally:
			self.lock.release()
			return return_value
	
	def get_user(self, username:str, password:str) -> Optional[User]:
		self.lock.acquire()
		cursor = self.conection.cursor()
		cursor.execute("""SELECT * FROM users WHERE name=?""", 
				 (username,))
		row: tuple = cursor.fetchone()
		if row is None:
			self.lock.release()
			return None
		if bcrypt.checkpw(password.encode(), row[3]):
			user = User(row[1], row[2], row[4])
		else:
			user = None
		self.lock.release()
		return user

	def insert_image(self, user_id: int, image) -> Optional[int]:
		self.lock.acquire()
		cursor = self.conection.cursor()
		return_value: Optional[int] = None
		try:
			cursor.execute("""INSERT INTO images VALUES (NULL, ?, ?)""", 
				 (user_id, image))
			return_value = cursor.lastrowid
			self.conection.commit()
		except Exception as e:
			return_value = None
		finally:
			self.lock.release()
			return return_value
		
	def get_image(self, image_id:int) -> Optional[User]:
		self.lock.acquire()
		cursor = self.conection.cursor()
		cursor.execute("""SELECT * FROM images WHERE image_id=?""", 
				 (image_id,))
		row: tuple = cursor.fetchone()
		self.lock.release()
		return row