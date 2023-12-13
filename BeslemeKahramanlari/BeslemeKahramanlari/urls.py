from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
   	path('api/', include('MobileAPI.urls')),
   	path('panel/', include('AdminPanel.urls')),
   	path('accounts/', include('django.contrib.auth.urls'), name='login'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
