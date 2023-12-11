from . import views
from django.urls import path

urlpatterns = [
	path('login', views.login),
	path('register', views.register),
	path('logout', views.logout),
	path('share-post', views.share_post),
	path('get-posts', views.get_posts),
	path('get-post/<int:post_id>', views.get_post),
	path('get-food-points', views.get_food_points),
]
