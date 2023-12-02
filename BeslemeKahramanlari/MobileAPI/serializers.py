from rest_framework import serializers
from .models import BeslemeKahramani


class UserSerializer(serializers.ModelSerializer):
	class Meta:
		model = BeslemeKahramani
		fields = ('username', 'email')
