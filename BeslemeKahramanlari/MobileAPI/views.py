from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.response import Response
from rest_framework.status import *
from .serializers import UserSerializer
from rest_framework.authtoken.models import Token
from django.shortcuts import get_object_or_404
from .models import BeslemeKahramani as User
from rest_framework.authentication import TokenAuthentication
from django.contrib.auth.decorators import user_passes_test
from rest_framework.authentication import SessionAuthentication
from rest_framework.permissions import IsAuthenticated

@api_view(['POST'])
def login(request):
	user = get_object_or_404(User, username=request.data['username'])
	if not user.check_password(request.data['password']):
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	else:
		token, _ = Token.objects.get_or_create(user=user)
		serializer = UserSerializer(instance=user)
		return Response({'token': token.key, 'user': serializer.data})


@api_view(['POST'])
def register(request):
	serializer = UserSerializer(data=request.data)
	if serializer.is_valid():
		user = serializer.save()
		user.set_password(request.data['password'])
		user.save()
		token, _ = Token.objects.get_or_create(user=user)
		return Response({'token': token.key, 'user': serializer.data})
	else:
		return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
def delete_user(request):
	request_user = request.user
	if not request_user.is_superuser:
		return Response({'error': 'You are not authorized to delete users'}, status=HTTP_401_UNAUTHORIZED)
	username = request.data.get('username')
	if not username:
		return Response({'error': 'Username not provided'}, status=HTTP_400_BAD_REQUEST)
	user = get_object_or_404(User, username=username)
	user.delete()
	return Response({'message': 'User deleted successfully'})
