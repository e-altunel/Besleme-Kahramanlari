class User:
	def __init__(self, name, email, authorization):
		self.name = name
		self.email = email
		self.authorization = authorization
	
	def __str__(self) -> str:
		return f"User: {self.name}, {self.email}, {self.authorization}"