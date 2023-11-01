from django.db import models
from django.contrib.auth.models import User
from FoodPoint.models import FoodPoint

# Create your models here.
class Post(models.Model):
	id = models.AutoField(primary_key=True)
	user = models.ForeignKey(User, on_delete=models.CASCADE)
	food_point = models.ForeignKey(FoodPoint, on_delete=models.CASCADE)
	title = models.CharField(max_length=100)
	content = models.TextField()
	date = models.DateTimeField(auto_now_add=True)
	image = models.ImageField(upload_to='PostApp/uploads', blank=False, null=False)

	def __str__(self) -> str:
		return f"{self.title} - {self.user.username} - ({self.id})"