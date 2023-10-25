import sqlite3
import threading
import bcrypt
from user import User
from typing import Optional
import logging
import re
from typing import Any


class Database:
	"""
	A class representing a SQLite database.

	Attributes:
	- database_name (str): The name of the database.
	- connection (sqlite3.Connection): The connection object for the database.
	- lock (threading.Lock): A lock object for thread safety.

	Methods:
	- __init__(self, database_name: str) -> None: Initializes the Database object.
	- create_tables(self) -> None: Creates the necessary tables in the database.
	- execute_query(self, query: str, params: tuple = None) -> list: Executes a query on the database.
	- insert(self, table: str, values: dict) -> None: Inserts a row into the specified table.
	- select(self, table: str, columns: list = None, where: str = None, params: tuple = None) -> list: Selects rows from the specified table.
	- update(self, table: str, values: dict, where: str = None, params: tuple = None) -> None: Updates rows in the specified table.
	- delete(self, table: str, where: str = None, params: tuple = None) -> None: Deletes rows from the specified table.
	"""

	def __init__(self, database_name: str) -> None:
		"""
		Initializes the Database object.

		Args:
		- database_name (str): The name of the database.

		Returns:
		- None
		"""
		try:
			logging.info(f"Connecting to database {database_name}")
			self.connection = sqlite3.connect(database_name)
			logging.info(f"Connected to database {database_name}")
			self.lock = threading.Lock()
			self.create_tables()
		except Exception as e:
			logging.error(e)
			self.connection = None

	def __del__(self):
		self.conection.close()

	@staticmethod
	def check_values_not_none(*args: Any) -> bool:
		"""
		Checks if all given values are not None.

		Args:
		- *args (Any): The values to check.

		Returns:
		- bool: True if all values are not None, False otherwise.
		"""
		for arg in args:
			if arg is None:
				return False
		return True

	def create_tables(self) -> None:
		"""
		Creates the necessary tables in the database.

		Args:
		- None

		Returns:
		- None
		"""
		logging.info("Creating tables")
		if self.conection is None:
			logging.error("Database not connected")
			return
		self.lock.acquire()
		cursor = self.conection.cursor()
		cursor.execute(
			"""CREATE TABLE IF NOT EXISTS users (
				user_id			INTEGER PRIMARY KEY AUTOINCREMENT,
				username		TEXT,
				email			TEXT,
				password		BLOB,
				authorization	INTEGER,
				UNIQUE(name, email))
				"""
		)
		cursor.execute(
			"""CREATE TABLE IF NOT EXISTS images (
				image_id	INTEGER PRIMARY KEY AUTOINCREMENT, 
				user_id		INTEGER,
				image_data	BLOB)
				"""
		)
		self.conection.commit()
		self.lock.release()

	def insert_user(
		self, username: str, email: str, password: str, authorization: int
	) -> Optional[int]:
		"""
		Inserts a new user into the database.

		Args:
		- username (str): The username of the user.
		- email (str): The email of the user.
		- password (str): The password of the user.
		- authorization (int): The authorization level of the user.

		Returns:
		- Optional[int]: The ID of the user, or None if the user was not inserted or if one or more values are None.
		"""
		logging.info(f"Inserting new user with name {username}")
		if not self.check_values_not_none(username, email, password, authorization):
			logging.error("One or more values are None")
			return None
		try:
			User.check_valid_user(username, email, password, authorization)
		except ValueError as e:
			logging.error(e)
			return None
		self.lock.acquire()
		cursor = self.conection.cursor()
		user_id: Optional[int] = None
		try:
			cursor.execute(
				"""INSERT INTO users VALUES (NULL, ?, ?, ?, ?)""",
				(
					username,
					email,
					bcrypt.hashpw(password.encode(), bcrypt.gensalt()),
					authorization,
				),
			)
			user_id = cursor.lastrowid
			self.conection.commit()
			logging.info(f"{username} inserted successfully with id {user_id}")
		except Exception as e:
			logging.error(e)
			user_id = None
		finally:
			self.lock.release()
			return user_id

	def get_user(self, username: str, password: str) -> Optional[User]:
		"""
		Retrieves a user from the database with the given username and password.

		Args:
		- username (str): The username of the user.
		- password (str): The password of the user.

		Returns:
		- Optional[User]: The user, or None if the user was not found or if one or more values are None.
		"""
		logging.info(f"Getting user with name {username}")
		if not self.check_values_not_none(username, password):
			logging.error("One or more values are None")
			return None
		try:
			User.check_valid_name(username)
			User.check_valid_password(password)
		except ValueError as e:
			logging.error(e)
			return None
		self.lock.acquire()
		cursor = self.conection.cursor()
		cursor.execute("""SELECT * FROM users WHERE name=?""", (username,))
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

	def insert_image(self, user_id: int, image: bytearray) -> Optional[int]:
		logging.info(f"Inserting image for user with id {user_id}")
		if not self.check_values_not_none(user_id, image):
			logging.error("One or more values are None")
			return None
		self.lock.acquire()
		cursor = self.conection.cursor()
		image_id: Optional[int] = None
		try:
			cursor.execute(
				"""INSERT INTO images VALUES (NULL, ?, ?)""", (user_id, image)
			)
			image_id = cursor.lastrowid
			self.conection.commit()
			logging.info(f"Image inserted successfully with id {image_id}")
		except Exception as e:
			logging.error(e)
			image_id = None
		finally:
			self.lock.release()
			return image_id

	class Database:
		def __init__(self, db_path: str):
			"""
			Initializes a new instance of the Database class.

			Args:
					db_path (str): The path to the SQLite database file.
			"""
			self.db_path = db_path
			self.conection = sqlite3.connect(db_path)
			self.lock = threading.Lock()

		def check_values_not_none(self, *values: Any) -> bool:
			"""
			Checks if all given values are not None.

			Args:
					*values (Any): The values to check.

			Returns:
					bool: True if all values are not None, False otherwise.
			"""
			return all(value is not None for value in values)

		def get_image(self, image_id: int) -> Optional[bytearray]:
			"""
			Retrieves an image from the database with the given image_id.

			Args:
					image_id (int): The ID of the image to retrieve.

			Returns:
					Optional[bytearray]: The image data as a bytearray, or None if the image was not found or if one or more values are None.
			"""
			logging.info(f"Getting image with id {image_id}")
			if not self.check_values_not_none(image_id):
				logging.error("One or more values are None")
				return None
			self.lock.acquire()
			cursor = self.conection.cursor()
			cursor.execute(
				"""SELECT * FROM images WHERE image_id=?""", (image_id,))
			row: tuple = cursor.fetchone()
			if row is None:
				self.lock.release()
				return None
			self.lock.release()
			return row[2]
