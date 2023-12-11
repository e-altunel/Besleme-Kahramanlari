from django.urls import path
from . import views

urlpatterns = [
	path('login/', views.login, name='login'),
	path('feed_points', views.feed_points, name='feed_points'),
	path('feed_points_edit/<int:id>', views.feed_points_edit, name='feed_points_edit'),
	path('feed_points_delete/<int:id>',
	     views.feed_points_delete, name='feed_points_delete'),
	path('feed_points_add', views.feed_points_add, name='feed_points_add'),
	path('users', views.users, name='users'),
	path('users_ban/<int:id>', views.users_ban, name='users_ban'),
	path('users_unban/<int:id>', views.users_unban, name='users_unban'),
]
