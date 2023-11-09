from django.shortcuts import render, redirect
from .forms import UserRegisterForm
from django.contrib.auth import login
from django.contrib.admin.views.decorators import staff_member_required
from .models import Report
from PostApp.models import Post
from django.contrib import messages


# Create your views here.
def RegisterView(request):
    if request.method == "POST":
        form = UserRegisterForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect("home")
    else:
        form = UserRegisterForm()
    return render(request, "registration/register.html", {"form": form})


@staff_member_required
def ReportListView(request):
    if request.method == "POST":
        delete_post_id = request.POST.get("delete_post_id")
        if delete_post_id:
            try:
                post = Post.objects.get(id=delete_post_id)
                post.delete()
                messages.success(request, "Post deleted")
                return redirect("report_list")
            except Report.DoesNotExist:
                messages.error(request, "Post not found")
                return redirect("report_list")

    reports = Report.objects.all()
    return render(request, "report_list.html", {"reports": reports})
