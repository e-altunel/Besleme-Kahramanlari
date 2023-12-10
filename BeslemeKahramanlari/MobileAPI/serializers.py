from rest_framework import serializers
from .models import *


class UserSerializer(serializers.ModelSerializer):
	class Meta:
		model = BeslemeKahramani
		fields = ('username', 'password', 'phone')


class FeedPointSerializer(serializers.ModelSerializer):
	class Meta:
		model = FeedPoint
		fields = ('name', 'latitude', 'longitude')


class PostSerializer(serializers.ModelSerializer):
	class Meta:
		model = Post
		fields = ('user', 'description', 'image', 'food_amount', 'food_point')
