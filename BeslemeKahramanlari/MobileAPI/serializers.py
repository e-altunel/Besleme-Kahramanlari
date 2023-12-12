from rest_framework import serializers
from .models import *


class UserSerializer(serializers.ModelSerializer):
	class Meta:
		model = BeslemeKahramani
		fields = ('username', 'password', 'email')


class FeedPointSerializer(serializers.ModelSerializer):
	class Meta:
		model = FeedPoint
		fields = ('name', 'latitude', 'longitude')


class PostSerializer(serializers.ModelSerializer):
	class Meta:
		model = Post
		fields = ('image', 'food_amount', 'feed_point')
