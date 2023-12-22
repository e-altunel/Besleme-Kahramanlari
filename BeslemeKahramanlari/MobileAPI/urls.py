from . import views
from django.urls import path

urlpatterns = [
	path('login', views.login),
	path('register', views.register),
	path('logout', views.logout),
	path('share-post', views.share_post),
	path('get-posts', views.get_posts),
	path('get-user-posts', views.get_user_posts),
	path('get-post/<int:post_id>', views.get_post),
	path('get-feed-points', views.get_feed_points),
	path('report-post', views.report_post),
	path('get-profile', views.get_profile),
]
