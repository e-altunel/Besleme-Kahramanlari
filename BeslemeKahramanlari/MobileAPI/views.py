from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.status import *
from .serializers import UserSerializer
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404


@api_view(['POST'])
def login(request):
	user = get_object_or_404(User, username=request.data['username'])
	if not user.check_password(request.data['password']):
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	else:
		token, _ = Token.objects.get_or_create(user=user)
		serializer = UserSerializer(instance=user)
		return Response({'token': token.key, 'user': serializer.data})
