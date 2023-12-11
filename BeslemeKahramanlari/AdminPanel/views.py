from django.shortcuts import render, redirect
from MobileAPI.models import *
from .forms import *
from django.contrib.auth.decorators import login_required, user_passes_test


def login(request):
	return render(request, 'AdminPanel/login.html')


@login_required(login_url='login')
@user_passes_test(lambda u: u.is_staff)
def feed_points(request):
	feed_points = FeedPoint.objects.all()
	return render(request, 'AdminPanel/feed_points.html', {'table_data': feed_points})


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
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


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def feed_points_delete(request, id):
	feed_point = FeedPoint.objects.get(id=id)
	feed_point.delete()
	return redirect('feed_points')


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def feed_points_add(request):
	if request.method == 'POST':
		form = FeedPointForm(request.POST)
		if form.is_valid():
			form.save()
			return redirect('feed_points')
	else:
		form = FeedPointForm()
	return render(request, 'AdminPanel/feed_points_add.html', {'form': form})


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def users(request):
	users = BeslemeKahramani.objects.all()
	return render(request, 'AdminPanel/users.html', {'table_data': users})


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def users_ban(request, id):
	user = BeslemeKahramani.objects.get(id=id)
	user.is_active = False
	user.save()
	return redirect('users')


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def users_unban(request, id):
	user = BeslemeKahramani.objects.get(id=id)
	user.is_active = True
	user.save()
	return redirect('users')
