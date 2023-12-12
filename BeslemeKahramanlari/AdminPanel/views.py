from django.shortcuts import render, redirect
from MobileAPI.models import *
from .forms import *
from django.contrib.auth.decorators import login_required, user_passes_test


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
def users_view(request, id):
	user = BeslemeKahramani.objects.get(id=id)
	return render(request, 'AdminPanel/users_view.html', {'user': user})

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


@user_passes_test(lambda u: u.is_superuser)
@login_required(login_url='login')
def users_staff(request, id):
	user = BeslemeKahramani.objects.get(id=id)
	user.is_staff = True
	user.save()
	return redirect('users')


@user_passes_test(lambda u: u.is_superuser)
@login_required(login_url='login')
def users_unstaff(request, id):
	user = BeslemeKahramani.objects.get(id=id)
	user.is_staff = False
	user.save()
	return redirect('users')


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def reports(request):
	reports = Report.objects.all().filter(is_active=True)
	return render(request, 'AdminPanel/reports.html', {"table_data": reports})


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def reports_view(request, id):
	if request.method == 'POST':
		report = Report.objects.get(id=id)
		report.is_active = False
		report.save()
		report.post.is_active = False
		report.post.save()
		return redirect('reports')
	report = Report.objects.get(id=id)
	return render(request, 'AdminPanel/reports_view.html', {"report": report})


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def posts(request):
	posts = Post.objects.all().filter(is_active=True)
	return render(request, 'AdminPanel/posts.html', {"table_data": posts})


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def posts_view(request, id):
	post = Post.objects.get(id=id)
	return render(request, 'AdminPanel/posts_view.html', {"post": post})


@user_passes_test(lambda u: u.is_staff)
@login_required(login_url='login')
def posts_hide(request, id):
	post = Post.objects.get(id=id)
	post.is_active = False
	post.save()
	return redirect('posts')
