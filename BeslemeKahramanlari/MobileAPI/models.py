from django.db import models
from django.contrib.auth.models import AbstractUser, UserManager, PermissionsMixin


class BKManager(UserManager):
	def _create_user(self, password, **args):
		user = self.model(**args)
		user.set_password(password)
		user.save(using=self._db)
		return user

	def create_user(self, password=None, **args):
		args.setdefault('is_superuser', False)
		args.setdefault('is_staff', False)
		return self._create_user(password, **args)

	def create_superuser(self, password, **args):
		args.setdefault('is_superuser', True)
		args.setdefault('is_staff', True)
		return self._create_user(password, **args)


class BeslemeKahramani(AbstractUser, PermissionsMixin):
	# Basic User Fields
	userid = models.AutoField(primary_key=True)
	username = models.CharField(
		max_length=50, unique=True, blank=False, null=False, db_index=True)
	name = models.CharField(max_length=50, blank=True, null=True, default=None)
	last_name = models.CharField(
		max_length=50, blank=True, null=True, default=None)
	phone = models.CharField(max_length=20, blank=True, null=True, default=None)
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

	class Meta:
		verbose_name = 'Besleme Kahramani'
		verbose_name_plural = 'Besleme Kahramanlari'

	def get_full_name(self) -> str:
		return f'{self.name} {self.last_name}'

	def get_short_name(self) -> str:
		return self.username
