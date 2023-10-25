import re


class User:
	"""
	A class representing a user.

	Attributes:
	- id (int): The user's ID.
	- name (str): The user's name.
	- email (str): The user's email.
	- authorization (int): The user's authorization level.

	Methods:
	- __init__(self, id: int, name: str, email: str, authorization: int): Constructs a new User object.
	- __str__(self) -> str: Returns a string representation of the User object.
	- check_valid_user(name: str, email: str, password: str, authorization: int) -> bool: Checks if a user is valid.
	- check_valid_name(name: str) -> bool: Checks if a name is valid.
	- check_valid_email(email: str) -> bool: Checks if an email is valid.
	- check_valid_password(password: str) -> bool: Checks if a password is valid.
	- check_valid_authorization(authorization: int) -> bool: Checks if an authorization level is valid.
	"""

	def __init__(self, id: int, name: str, email: str, authorization: int):
		"""
		Constructs a new User object.

		Args:
		- id (int): The user's ID.
		- name (str): The user's name.
		- email (str): The user's email.
		- authorization (int): The user's authorization level.
		"""
		self.id = id
		self.name = name
		self.email = email
		self.authorization = authorization

	def __str__(self) -> str:
		"""
		Returns a string representation of the User object.
		
		Returns:
		- str: A string representation of the User object.
		"""
		return f"User: {self.name}, {self.email}, {self.authorization}"

	@staticmethod
	def check_valid_user(
			name: str, email: str, password: str, authorization: int
	) -> bool:
		"""
		Checks if a user is valid.
					
		Args:
		- name (str): The name of the user.
		- email (str): The email of the user.
		- password (str): The password of the user.
		- authorization (int): The authorization level of the user.
					
		Returns:
		- bool: True if the user is valid, False otherwise.
		"""
		return (
			User.check_valid_name(name)
			and User.check_valid_email(email)
			and User.check_valid_password(password)
			and User.check_valid_authorization(authorization)
		)

	@staticmethod
	def check_valid_name(name: str) -> bool:
		if len(name) > 32 or len(name) < 6:
			raise ValueError("Name must be between 6 and 32 characters")
		if re.match(r"[a-zA-Z][a-zA-Z0-9\._]+", name) is None:
			raise ValueError(
				"Name must start with a letter and contain only alphanumeric characters, underscores, and periods"
			)
		return True

	@staticmethod
	def check_valid_email(email: str) -> bool:
		if len(email) > 64 or len(email) < 6:
			raise ValueError("Email must be between 6 and 64 characters")
		if re.match(r"[^@]+@[^@]+\.[^@]+", email) is None:
			raise ValueError("Email must be a valid email address")
		return True

	@staticmethod
	def check_valid_password(password: str) -> bool:
		if len(password) < 8 or len(password) > 32:
			raise ValueError("Password must be between 8 and 32 characters")
		if re.search("[a-z]", password) is None:
			raise ValueError(
				"Password must contain at least one lowercase letter")
		if re.search("[A-Z]", password) is None:
			raise ValueError(
				"Password must contain at least one uppercase letter")
		if re.search("[0-9]", password) is None:
			raise ValueError("Password must contain at least one number")
		if not password.isalnum():
			raise ValueError(
				"Password must contain only alphanumeric characters")
		return True

	@staticmethod
	def check_valid_authorization(authorization: int) -> bool:
		if authorization < 0 or authorization > 2:
			raise ValueError("Authorization must be between 0 and 2")
		return True
