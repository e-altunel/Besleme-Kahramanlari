from django.urls import path
from PostApp import views
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path("", views.PostListView, name="post_list"),
    path("<int:post_id>/", views.PostDetailView, name="post_detail"),
    path("e/404/", views.PostNotFoundView, name="Post_404"),
    path("upload/", views.PostUploadView, name="post_upload"),
]
