from django.urls import include, path
from .views import *

urlpatterns = [
    path("", include("django.contrib.auth.urls")),
    path("register/", RegisterView, name="register"),
    path("reports/", ReportListView, name="report_list"),
]
