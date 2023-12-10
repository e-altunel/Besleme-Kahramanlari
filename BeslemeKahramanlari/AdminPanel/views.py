from django.shortcuts import render, redirect
from MobileAPI.models import *
from .forms import *
# Create your views here.


def feed_points(request):
	feed_points = FeedPoint.objects.all()
	return render(request, 'AdminPanel/feed_points.html', {'table_data': feed_points})


def feed_points_edit(request, id):
	feed_point = FeedPoint.objects.get(id=id)
	if request.method == 'POST':
		form = FeedPointForm(request.POST, instance=feed_point)
		if form.is_valid():
			form.save()
			return redirect('feed_points')
	else:
		form = FeedPointForm(instance=feed_point)
	return render(request, 'AdminPanel/feed_points_edit.html', {'form': form, 'feed_point': feed_point})


def feed_points_delete(request, id):
	feed_point = FeedPoint.objects.get(id=id)
	feed_point.delete()
	return redirect('feed_points')


def feed_points_add(request):
	if request.method == 'POST':
		form = FeedPointForm(request.POST)
		if form.is_valid():
			form.save()
			return redirect('feed_points')
	else:
		form = FeedPointForm()
	return render(request, 'AdminPanel/feed_points_add.html', {'form': form})
