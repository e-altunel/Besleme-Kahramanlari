from django.db import models

# Create your models here.
class FoodPoint(models.Model):
	id = models.AutoField(primary_key=True)
	title = models.CharField(max_length=100)

	def __str__(self) -> str:
		return self.title