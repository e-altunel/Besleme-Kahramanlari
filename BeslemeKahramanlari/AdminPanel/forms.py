from django import forms
from MobileAPI.models import *


class FeedPointForm(forms.ModelForm):
	class Meta:
		model = FeedPoint
		field = ['name', 'latitude', 'longitude', 'food_amount']
		exclude = ['id', 'created_at', 'updated_at']
		widgets = {
			'name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Besleme Noktası Adı'}),
			'latitude': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Enlem'}),
			'longitude': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Boylam'}),
			'food_amount': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Yem Miktarı'}),
		}
