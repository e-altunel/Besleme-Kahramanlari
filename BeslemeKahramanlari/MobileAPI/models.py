from django.db import models
from django.contrib.auth.models import AbstractUser, UserManager, PermissionsMixin
from django.core.validators import RegexValidator
class BKManager(UserManager):
	def _create_user(self, username, password, **args):
		user = self.model(username=username, **args)
		user.set_password(password)
		user.save(using=self._db)
		return user

	def create_user(self, username, password, **args):
		args.setdefault('is_superuser', False)
		args.setdefault('is_staff', False)
		return self._create_user(username=username, password=password, **args)

	def create_superuser(self, username, password, **args):
		args.setdefault('is_superuser', True)
		args.setdefault('is_staff', True)
		return self._create_user(username=username, password=password, **args)


class BeslemeKahramani(AbstractUser, PermissionsMixin):
	username = models.CharField(
		max_length=50, unique=True, blank=False, null=False, db_index=True)
	name = models.CharField(max_length=50, blank=True, null=True, default=None)
	last_name = models.CharField(
		max_length=50, blank=True, null=True, default=None)
	email = models.EmailField(unique=True, blank=True, null=True, default=None)

	# Permissions
	is_staff = models.BooleanField(default=False)
	is_active = models.BooleanField(default=True)
	is_superuser = models.BooleanField(default=False)

	# Dates
	date_joined = models.DateTimeField(auto_now_add=True)
	date_last_login = models.DateTimeField(auto_now=True)

	# Besleme Kahramani Fields
	food_amount = models.FloatField(default=0)

	objects = BKManager()

	USERNAME_FIELD = 'username'
	REQUIRED_FIELDS = []

	def __str__(self):
		return self.username


class FeedPoint(models.Model):
	name = models.CharField(max_length=50, blank=False, null=False)
	latitude = models.FloatField(blank=False, null=False)
	longitude = models.FloatField(blank=False, null=False)
	food_amount = models.FloatField(default=0)
	created_at = models.DateTimeField(auto_now_add=True)
	updated_at = models.DateTimeField(auto_now=True)

	def __str__(self):
		return "{} - {}".format(self.name, self.food_amount)


class Post(models.Model):
	user = models.ForeignKey(
		BeslemeKahramani, on_delete=models.CASCADE, null=True)
	description = models.TextField(blank=False, null=False)
	image = models.ImageField(
		upload_to='posts', blank=True, null=True, default=None)
	created_at = models.DateTimeField(auto_now_add=True)
	food_amount = models.FloatField(default=0)
	feed_point = models.ForeignKey(FeedPoint, on_delete=models.CASCADE)
	is_active = models.BooleanField(default=True)

	def __str__(self):
		return "{} - {}".format(self.feed_point, self.user.username)


class Report(models.Model):
	reporter = models.ForeignKey(BeslemeKahramani, on_delete=models.CASCADE)
	post = models.ForeignKey(Post, on_delete=models.CASCADE)
	created_at = models.DateTimeField(auto_now_add=True)
	is_active = models.BooleanField(default=True)
