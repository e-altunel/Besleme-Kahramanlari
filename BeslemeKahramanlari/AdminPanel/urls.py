from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static
from django.views.generic.base import RedirectView

urlpatterns = [
	# redirect to feed_points
	path('', RedirectView.as_view(url='feed_points')),
	path('login', views.login_view, name='login'),
	path('login/', views.login_view),
	path('logout', views.logout_view, name='logout'),
	path('logout/', views.logout_view),
	path('feed_points', views.feed_points, name='feed_points'),
	path('feed_points_edit/<int:id>', views.feed_points_edit, name='feed_points_edit'),
	path('feed_points_delete/<int:id>',
	     views.feed_points_delete, name='feed_points_delete'),
	path('feed_points_add', views.feed_points_add, name='feed_points_add'),
	path('users', views.users, name='users'),
	path('users_view/<int:id>', views.users_view, name='users_view'),
	path('users_ban/<int:id>', views.users_ban, name='users_ban'),
	path('users_unban/<int:id>', views.users_unban, name='users_unban'),
	path('users_staff/<int:id>', views.users_staff, name='users_staff'),
	path('users_unstaff/<int:id>', views.users_unstaff, name='users_unstaff'),
    path('users_delete/<int:id>', views.users_delete, name='users_delete'),
	path('reports', views.reports, name='reports'),
	path('reports_view/<int:id>', views.reports_view, name='reports_view'),
	path('reports_delete/<int:id>', views.reports_delete, name='reports_delete'),
	path('posts', views.posts, name='posts'),
	path('posts_view/<int:id>', views.posts_view, name='posts_view'),
	path('posts_unhide/<int:id>', views.posts_unhide, name='posts_unhide'),
	path('posts_hide/<int:id>', views.posts_hide, name='posts_hide'),
    path('posts_delete/<int:id>', views.posts_delete, name='posts_delete'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
