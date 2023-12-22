from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.response import Response
from rest_framework.status import *
from .serializers import *
from rest_framework.authtoken.models import Token
from django.shortcuts import get_object_or_404
from .models import BeslemeKahramani as User, Post
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated


@api_view(['POST'])
def login(request):
	user = get_object_or_404(User, username=request.data['username'])
	if user is None or not user.check_password(request.data['password']) or not user.is_active:
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	else:
		token, _ = Token.objects.get_or_create(user=user)
		serializer = UserSerializer(instance=user)
		return Response({'token': token.key, 'user': serializer.data})


@api_view(['POST'])
def register(request):
	serializer = UserSerializer(data=request.data)
	if 'password' not in request.data:
		return Response({'error': 'Password is missing'}, status=HTTP_400_BAD_REQUEST)
	if BeslemeKahramani.is_password_valid(request.data['password']):
		return Response({'error': 'Password is not valid'}, status=HTTP_400_BAD_REQUEST)
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
@permission_classes([IsAuthenticated])
def logout(request):
	if not request.user or not request.user.is_active:
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	if 'token' not in request.data:
		return Response({'error': 'Token is missing'}, status=HTTP_400_BAD_REQUEST)
	if request.user.auth_token is not None:
		return Response({'error': 'User is not logged in'}, status=HTTP_400_BAD_REQUEST)
	if request.user.auth_token.key != request.data['token']:
		return Response({'error': 'Token is invalid'}, status=HTTP_400_BAD_REQUEST)
	request.user.auth_token.delete()
	return Response(status=HTTP_200_OK)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_posts(request):
	if not request.user or not request.user.is_active:
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	posts_serial = PostSerializer(
		instance=Post.objects.order_by('-created_at').filter(is_active=True), many=True)
	if posts_serial is None:
		return Response({'error': 'Posts Not Found'}, status=HTTP_404_NOT_FOUND)
	return Response({'posts': posts_serial.data}, status=HTTP_200_OK)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_post(request, post_id):
	if 'post_id' not in request.data:
		return Response({'error': 'Post Id is missing'}, status=HTTP_400_BAD_REQUEST)
	if not request.user or not request.user.is_active:
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	post = get_object_or_404(Post, id=post_id)
	if post is None or not post.is_active:
		return Response({'error': 'Post Not Found'}, status=HTTP_404_NOT_FOUND)
	post_serial = PostSerializer(instance=post)
	return Response({'post': post_serial.data}, status=HTTP_200_OK)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_feed_points(request):
	if not request.user or not request.user.is_active:
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	latitude = request.data.get('latitude')
	longitude = request.data.get('longitude')

	if latitude is None or longitude is None:
		return Response({'error': 'Latitude or Longitude is missing'}, status=HTTP_400_BAD_REQUEST)

	feed_points = FeedPoint.objects.all()
	feed_points.filter(latitude__gte=latitude-0.1, latitude__lte=latitude +
	                   0.1).filter(longitude__gte=longitude-0.1, longitude__lte=longitude+0.1)
	if feed_points.count() == 0:
		return Response({'error': 'No Feed Points Found'}, status=HTTP_404_NOT_FOUND)
	feed_points_serial = FeedPointSerializer(instance=feed_points, many=True)
	return Response({'feed_points': feed_points_serial.data}, status=HTTP_200_OK)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def share_post(request):
	if not request.user or not request.user.is_active:
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	serializer = PostSerializer(data=request.data)
	if serializer.is_valid():
		post = serializer.save()
		post.user = request.user
		post.save()
		post.user.food_amount += post.food_amount
		post.user.save()
		post.feed_point.food_amount += post.food_amount
		post.feed_point.save()
		return Response({'post': serializer.data}, status=HTTP_200_OK)
	else:
		print(serializer.errors)
		return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def report_post(request):
	if not request.user or not request.user.is_active:
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	if 'post_id' not in request.data:
		return Response({'error': 'Post Id is missing'}, status=HTTP_400_BAD_REQUEST)
	post = get_object_or_404(Post, id=request.data['post_id'])
	if post is None or not post.is_active:
		return Response({'error': 'Post Not Found'}, status=HTTP_404_NOT_FOUND)
	report = Report.objects.create(post=post, reporter=request.user)
	report.save()
	return Response(status=HTTP_200_OK)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_profile(request):
	if 'user_id' not in request.data:
		user = request.user
	else:
		user = get_object_or_404(User, id=request.data['user_id'])
	if user is None or not user.is_active:
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	user_serial = UserSerializer(instance=user)
	return Response({'user': user_serial.data}, status=HTTP_200_OK)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def change_password(request):
	old_password = request.data.get('old_password')
	new_password = request.data.get('new_password')
	if not request.user or not request.user.is_active:
		return Response({'error': 'User Not Found'}, status=HTTP_404_NOT_FOUND)
	if old_password is None or new_password is None:
		return Response({'error': 'Old or New Password is missing'}, status=HTTP_400_BAD_REQUEST)
	if not request.user.check_password(old_password):
		return Response({'error': 'Old Password is wrong'}, status=HTTP_400_BAD_REQUEST)
	if old_password == new_password:
		return Response({'error': 'Old and New Passwords are same'}, status=HTTP_400_BAD_REQUEST)
	if BeslemeKahramani.is_password_valid(new_password):
		return Response({'error': 'New Password is not valid'}, status=HTTP_400_BAD_REQUEST)
	request.user.set_password(new_password)
	request.user.save()
	return Response(status=HTTP_200_OK)

