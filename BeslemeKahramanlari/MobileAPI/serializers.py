from rest_framework import serializers
from .models import *


class UserSerializer(serializers.ModelSerializer):
    food_amount = serializers.ReadOnlyField()
    pk = serializers.ReadOnlyField()

    class Meta:
        model = BeslemeKahramani
        fields = (
            "username",
            "password",
            "email",
            "first_name",
            "last_name",
            "food_amount",
            "pk",
        )


class FeedPointSerializer(serializers.ModelSerializer):
    pk = serializers.ReadOnlyField()
    food_amount = serializers.ReadOnlyField()
    food_level = serializers.ReadOnlyField()

    def create(self, validated_data):
        feed_point = FeedPoint.objects.create(**validated_data)
        feed_point.calculate_food_level()
        return feed_point
    
    def update(self, instance, validated_data):
        feed_point = super().update(instance, validated_data)
        feed_point.calculate_food_level()
        return feed_point

    class Meta:
        model = FeedPoint
        fields = ("name", "latitude", "longitude", "food_amount", "pk", "food_level")


class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ("image", "food_amount", "feed_point")
