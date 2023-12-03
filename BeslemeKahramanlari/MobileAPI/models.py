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
	profile_picture = models.ImageField(
		upload_to='profile_pictures', blank=True, null=True, default=None)
	username = models.CharField(
		max_length=50, unique=True, blank=False, null=False, db_index=True)
	name = models.CharField(max_length=50, blank=True, null=True, default=None)
	last_name = models.CharField(
		max_length=50, blank=True, null=True, default=None)
	phone_regex = RegexValidator(regex=r'^\+?1?\d{9,15}$')
	phone = models.CharField(
		validators=[phone_regex, ], max_length=17, blank=True, null=True, default=None, unique=True)
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
