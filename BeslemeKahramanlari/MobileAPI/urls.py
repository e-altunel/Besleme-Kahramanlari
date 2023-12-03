from . import views
from django.urls import path

urlpatterns = [
	path('login', views.login),
	path('register', views.register),
	path('admin/delete_user', views.delete_user),
]
