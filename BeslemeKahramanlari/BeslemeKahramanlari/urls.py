from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.views.generic.base import RedirectView

urlpatterns = [
    path('', RedirectView.as_view(url='panel/feed_points')),
    path('admin/', admin.site.urls),
   	path('api/', include('MobileAPI.urls')),
   	path('panel/', include('AdminPanel.urls')),
   	path('panel/', include('django.contrib.auth.urls')),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
