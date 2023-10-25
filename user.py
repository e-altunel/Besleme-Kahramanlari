class User:
	def __init__(self, id: int, name: str, email: str, authorization: int):
		self.id = id
		self.name = name
		self.email = email
		self.authorization = authorization
	
	def __str__(self) -> str:
		return f"User: {self.name}, {self.email}, {self.authorization}"