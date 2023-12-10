from django.urls import path
from . import views

urlpatterns = [
	path('feed_points', views.feed_points, name='feed_points'),
	path('feed_points_edit/<int:id>', views.feed_points_edit, name='feed_points_edit'),
	path('feed_points_delete/<int:id>',
	     views.feed_points_delete, name='feed_points_delete'),
	path('feed_points_add', views.feed_points_add, name='feed_points_add'),
]
