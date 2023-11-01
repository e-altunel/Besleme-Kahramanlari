from django.urls import path
from PostApp import views

urlpatterns = [
	path('<int:post_id>', views.PostDetailView, name='post_detail'),
	path('e/404', views.PostNotFoundView, name='Post_404')
]
