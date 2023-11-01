from django.shortcuts import render, redirect
from .models import Post
from django.contrib import messages

# Create your views here.
def PostDetailView(request, post_id):
	try:
		post = Post.objects.get(id=post_id)
		if post is not None:
			return render(request, 'post_detail.html', {'post': post})
	except Post.DoesNotExist:
		messages.error(request, 'Post does not exist')
		return redirect('Post_404')

def PostNotFoundView(request):
	return render(request, 'post_404.html')