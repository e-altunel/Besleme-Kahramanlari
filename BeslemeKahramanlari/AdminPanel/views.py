from django.shortcuts import render, redirect
from MobileAPI.models import *
from .forms import *
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout

# region Admin Panel Views
# region Login View


def login_view(request):
	if request.method == 'POST':
		username = request.POST.get('username')
		password = request.POST.get('password')
		if not username or not password:
			messages.error(request, "Username or Password is empty")
			return redirect('login')
		user = authenticate(username=username, password=password)
		if user is None or not user.is_active:
			messages.error(request, "User Not Found")
			return redirect('login')
		if request.user.is_authenticated:
			logout(request)
		login(request, user)
		if not user.is_staff:
			messages.error(request, "You don't have permission to do that")
			return redirect('login')
		return redirect('feed_points')
	else:
		form = LoginForm()
		return render(request, 'AdminPanel/login.html', {'form': form})


def logout_view(request):
	if not request.user.is_authenticated:
		messages.error(request, "You are not logged in")
		return redirect('login')
	logout(request)
	messages.success(request, "Logged out successfully")
	return redirect('login')

# endregion
# region Feed Points Views


@login_required
@user_passes_test(lambda u: u.is_staff)
def feed_points(request):
	feed_points = FeedPoint.objects.all()
	return render(request, 'AdminPanel/feed_points.html', {'table_data': feed_points})


@user_passes_test(lambda u: u.is_staff)
@login_required
def feed_points_edit(request, id):
	try:
		feed_point = FeedPoint.objects.get(id=id)
	except FeedPoint.DoesNotExist:
		messages.error(request, "Feed Point not found")
		return redirect('feed_points')
	if request.method == 'POST':
		form = FeedPointForm(request.POST, instance=feed_point)
		if not form.is_valid():
			messages.error(request, "Form is not valid")
			return redirect('feed_points')
		if not form.has_changed():
			messages.error(request, "Nothing changed")
			return redirect('feed_points')
		if form.cleaned_data.get('food_amount') < 0:
			messages.error(request, "Food Amount can't be negative")
			return redirect('feed_points')
		if form.cleaned_data.get('latitude') < -90 or form.cleaned_data.get('latitude') > 90:
			messages.error(request, "Latitude must be between -90 and 90")
			return redirect('feed_points')
		if form.cleaned_data.get('longitude') < -180 or form.cleaned_data.get('longitude') > 180:
			messages.error(request, "Longitude must be between -180 and 180")
			return redirect('feed_points')
		messages.success(request, "Feed Point updated successfully")
		form.save()
		return redirect('feed_points')
	else:
		form = FeedPointForm(instance=feed_point)
	return render(request, 'AdminPanel/feed_points_edit.html', {'form': form, 'feed_point': feed_point})


@user_passes_test(lambda u: u.is_staff)
@login_required
def feed_points_delete(request, id):
	try:
		feed_point = FeedPoint.objects.get(id=id)
	except FeedPoint.DoesNotExist:
		messages.error(request, "Feed Point not found")
		return redirect('feed_points')
	messages.success(request, "Feed Point deleted successfully")
	feed_point.delete()
	return redirect('feed_points')


@user_passes_test(lambda u: u.is_staff)
@login_required
def feed_points_add(request):
	if request.method == 'POST':
		try:
			form = FeedPointForm(request.POST)
		except:
			messages.error(request, "Form is not valid")
			return render(request, 'AdminPanel/feed_points_add.html', {'form': form})
		if not form.is_valid():
			messages.error(request, "Form is not valid")
			return render(request, 'AdminPanel/feed_points_add.html', {'form': form})
		if form.cleaned_data.get('food_amount') < 0:
			messages.error(request, "Food Amount can't be negative")
			return render(request, 'AdminPanel/feed_points_add.html', {'form': form})
		if form.cleaned_data.get('latitude') < -90 or form.cleaned_data.get('latitude') > 90:
			messages.error(request, "Latitude must be between -90 and 90")
			return render(request, 'AdminPanel/feed_points_add.html', {'form': form})
		if form.cleaned_data.get('longitude') < -180 or form.cleaned_data.get('longitude') > 180:
			messages.error(request, "Longitude must be between -180 and 180")
			return render(request, 'AdminPanel/feed_points_add.html', {'form': form})
		messages.success(request, "Feed Point added successfully")
		form.save()
		return redirect('feed_points')
	else:
		form = FeedPointForm()
	return render(request, 'AdminPanel/feed_points_add.html', {'form': form})


# endregion
# region Users Views

@user_passes_test(lambda u: u.is_staff)
@login_required
def users(request):
	users = BeslemeKahramani.objects.all()
	return render(request, 'AdminPanel/users.html', {'table_data': users})


@user_passes_test(lambda u: u.is_staff)
@login_required
def users_view(request, id):
	if not request.user.is_staff:
		messages.error(request, "You don't have permission to do that")
		return redirect('users')
	try:
		user = BeslemeKahramani.objects.get(id=id)
	except BeslemeKahramani.DoesNotExist:
		messages.error(request, "User not found")
		return redirect('users')
	if user.is_superuser:
		messages.error(request, "You can't view superuser")
		return redirect('users')
	return render(request, 'AdminPanel/users_view.html', {'user': user})

@user_passes_test(lambda u: u.is_staff)
@login_required
def users_ban(request, id):
	if not request.user.is_staff:
		messages.error(request, "You don't have permission to do that")
		return redirect('users')
	if request.user.id == id:
		messages.error(request, "You can't ban yourself")
		return redirect('users')
	try:
		user = BeslemeKahramani.objects.get(id=id)
	except BeslemeKahramani.DoesNotExist:
		messages.error(request, "User not found")
		return redirect('users')
	if user.is_superuser:
		messages.error(request, "You can't ban superuser")
		return redirect('users')
	if user.is_active == False:
		messages.error(request, "User is already banned")
		return redirect('users')
	if user.is_staff and not request.user.is_superuser:
		messages.error(request, "You can't ban staff")
		return redirect('users')
	user.is_active = False
	user.save()
	messages.success(request, "User is banned now")
	return redirect('users')


@user_passes_test(lambda u: u.is_staff)
@login_required
def users_unban(request, id):
	if not request.user.is_staff:
		messages.error(request, "You don't have permission to do that")
		return redirect('users')
	if request.user.id == id:
		messages.error(request, "You can't unban yourself")
		return redirect('users')
	try:
		user = BeslemeKahramani.objects.get(id=id)
	except BeslemeKahramani.DoesNotExist:
		messages.error(request, "User not found")
		return redirect('users')
	if user.is_superuser:
		messages.error(request, "You can't unban superuser")
		return redirect('users')
	if user.is_active:
		messages.error(request, "User is not banned")
		return redirect('users')
	if user.is_staff and not request.user.is_superuser:
		messages.error(request, "You can't unban staff")
		return redirect('users')
	user.is_active = True
	user.save()
	messages.success(request, "User is not banned anymore")
	return redirect('users')


@user_passes_test(lambda u: u.is_superuser)
@login_required
def users_staff(request, id):
	if not request.user.is_superuser:
		messages.error(request, "You don't have permission to do that")
		return redirect('users')
	if request.user.id == id:
		messages.error(request, "You can't staff yourself")
		return redirect('users')
	try:
		user = BeslemeKahramani.objects.get(id=id)
	except BeslemeKahramani.DoesNotExist:
		messages.error(request, "User not found")
		return redirect('users')
	if user.is_active == False:
		messages.error(request, "You can't staff banned user")
		return redirect('users')
	if user.is_superuser:
		messages.error(request, "You can't staff superuser")
		return redirect('users')
	if user.is_staff:
		messages.error(request, "User is already staff")
		return redirect('users')
	user.is_staff = True
	user.save()
	messages.success(request, "User is staff now")
	return redirect('users')


@user_passes_test(lambda u: u.is_superuser)
@login_required
def users_unstaff(request, id):
	if not request.user.is_superuser:
		messages.error(request, "You don't have permission to do that")
		return redirect('users')
	if request.user.id == id:
		messages.error(request, "You can't unstaff yourself")
		return redirect('users')
	try:
		user = BeslemeKahramani.objects.get(id=id)
	except BeslemeKahramani.DoesNotExist:
		messages.error(request, "User not found")
		return redirect('users')
	if user.is_superuser:
		messages.error(request, "You can't unstaff superuser")
		return redirect('users')
	if not user.is_staff:
		messages.error(request, "User is not staff")
		return redirect('users')
	user.is_staff = False
	user.save()
	messages.success(request, "User is not staff anymore")
	return redirect('users')

# endregion
# region Reports Views

@user_passes_test(lambda u: u.is_staff)
@login_required
def reports(request):
	reports = Report.objects.all().filter(is_active=True)
	return render(request, 'AdminPanel/reports.html', {"table_data": reports})


@user_passes_test(lambda u: u.is_staff)
@login_required
def reports_view(request, id):
	if request.method == 'POST':
		try:
			report = Report.objects.get(id=id)
		except Report.DoesNotExist:
			messages.error(request, "Report not found")
			return redirect('reports')
		if not report.is_active:
			messages.error(request, "Report is already solved")
			return redirect('reports')
		report.is_active = False
		report.save()
		if not report.post:
			messages.error(request, "Post not found")
			return redirect('reports')
		if not report.post.is_active:
			messages.error(request, "Post is already hidden")
			return redirect('reports')
		report.post.is_active = False
		report.post.save()
		messages.success(request, "Report is solved successfully")
		return redirect('reports')
	try:
		report = Report.objects.get(id=id)
	except Report.DoesNotExist:
		messages.error(request, "Report not found")
		return redirect('reports')
	if not report.is_active:
		messages.error(request, "Report is already solved")
		return redirect('reports')
	return render(request, 'AdminPanel/reports_view.html', {"report": report})

# endregion
# region Posts Views

@user_passes_test(lambda u: u.is_staff)
@login_required
def posts(request):
	posts = Post.objects.all().filter(is_active=True)
	return render(request, 'AdminPanel/posts.html', {"table_data": posts})


@user_passes_test(lambda u: u.is_staff)
@login_required
def posts_view(request, id):
	try:
		post = Post.objects.get(id=id)
	except Post.DoesNotExist:
		messages.error(request, "Post not found")
		return redirect('posts')
	if not post.is_active:
		messages.error(request, "Post not found")
		return redirect('posts')
	return render(request, 'AdminPanel/posts_view.html', {"post": post})


@user_passes_test(lambda u: u.is_staff)
@login_required
def posts_hide(request, id):
	try:
		post = Post.objects.get(id=id)
	except Post.DoesNotExist:
		messages.error(request, "Post not found")
		return redirect('posts')
	if not post.is_active:
		messages.error(request, "Post not found")
		return redirect('posts')
	post.is_active = False
	post.save()
	return redirect('posts')

# endregion
# endregion
