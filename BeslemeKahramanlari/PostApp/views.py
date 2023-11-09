from django.shortcuts import render, redirect
from .models import Post
from django.contrib import messages
from .forms import PostForm
from Account.models import Report


def PostListView(request):
    if request.method == "POST":
        delete_post_id = request.POST.get("delete_post_id")
        if delete_post_id:
            if request.user.is_staff:
                try:
                    post = Post.objects.get(id=delete_post_id)
                    post.delete()
                    messages.success(request, "Post deleted successfully")
                    return redirect("post_list")
                except Post.DoesNotExist:
                    messages.error(request, "Post does not exist")
                    return redirect("post_list")
            else:
                messages.error(request, "You are not authorized to delete posts")
                return redirect("post_list")
        report_post_id = request.POST.get("report_post_id")
        if report_post_id:
            if request.user.is_authenticated:
                try:
                    post = Post.objects.get(id=report_post_id)
                    Report(post_id=post, reported_by=request.user).save()
                    messages.success(request, "Post reported successfully")
                    return redirect("post_list")
                except Post.DoesNotExist:
                    messages.error(request, "Post does not exist")
                    return redirect("post_list")
            else:
                messages.error(request, "You have to be logged in to report posts")
                return redirect("post_list")
    posts = Post.objects.all()
    return render(request, "post_list.html", {"posts": posts})


# Create your views here.
def PostDetailView(request, post_id):
    try:
        post = Post.objects.get(id=post_id)
        if post:
            return render(request, "post_detail.html", {"post": post})
        else:
            return redirect("Post_404")
    except Post.DoesNotExist:
        messages.error(request, "Post does not exist")
        return redirect("Post_404")


def PostUploadView(request):
    if request.method == "POST":
        form = PostForm(request.POST, request.FILES)
        form.instance.user = request.user
        if form.is_valid():
            form.save()
            messages.success(request, "Post uploaded successfully")
            return redirect("post_detail", post_id=form.instance.id)
        else:
            messages.error(request, "Post could not be uploaded")
            return render(request, "post_upload.html", {"form": form})
    else:
        form = PostForm()
        return render(request, "post_upload.html", {"form": form})


def PostNotFoundView(request):
    return render(request, "post_404.html")
