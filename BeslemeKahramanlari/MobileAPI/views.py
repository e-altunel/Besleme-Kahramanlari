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
	request.user.auth_token.delete()
	return Response(status=HTTP_200_OK)


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_posts(request):
	posts_serial = PostSerializer(
		instance=Post.objects.order_by('-created_at')[:10], many=True)
	return Response({'posts': posts_serial.data}, status=HTTP_200_OK)


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_post(request, post_id):
	post_serial = PostSerializer(instance=get_object_or_404(Post, id=post_id))
	return Response({'post': post_serial.data}, status=HTTP_200_OK)


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_feed_points(request):
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
	serializer = PostSerializer(data=request.data)
	if serializer.is_valid():
		post = serializer.save()
		post.user = request.user
		post.save()
		return Response({'post': serializer.data}, status=HTTP_200_OK)
	else:
		print(serializer.errors)
		return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def report_post(request):
	post = get_object_or_404(Post, id=request.data['post_id'])
	if post is None or not post.is_active:
		return Response({'error': 'Post Not Found'}, status=HTTP_404_NOT_FOUND)
	report = Report.objects.create(post=post, reporter=request.user)
	report.save()
	return Response(status=HTTP_200_OK)
