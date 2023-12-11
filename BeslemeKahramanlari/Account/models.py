from django.db import models
from django.contrib.auth.models import User
from PostApp.models import Post


# Create your models here.
class Report(models.Model):
	id = models.AutoField(primary_key=True)
	reported_by = models.ForeignKey(
		User, on_delete=models.CASCADE, blank=False, null=False
	)
	post_id = models.ForeignKey(Post, on_delete=models.CASCADE)
	created_at = models.DateTimeField(auto_now_add=True)
	
	def __str__(self) -> str:
		return f"{self.reported_by.username} - ({self.id})"
