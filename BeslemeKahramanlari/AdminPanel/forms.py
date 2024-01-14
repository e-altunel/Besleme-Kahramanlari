from django import forms
from MobileAPI.models import *


class FeedPointForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(FeedPointForm, self).__init__(*args, **kwargs)
        self.instance.calculate_food_level()

    class Meta:
        model = FeedPoint
        field = [
            "name",
            "latitude",
            "longitude",
        ]
        exclude = [
            "id",
            "created_at",
            "updated_at",
            "is_active",
            "food_amount",
            "food_avarage_amount",
            "last_calculated_at",
            "should_update",
        ]
        widgets = {
            "name": forms.TextInput(
                attrs={"class": "form-control", "placeholder": "Besleme Noktası Adı"}
            ),
            "latitude": forms.TextInput(
                attrs={"class": "form-control", "placeholder": "Enlem"}
            ),
            "longitude": forms.TextInput(
                attrs={"class": "form-control", "placeholder": "Boylam"}
            ),
            "food_level": forms.TextInput(
                attrs={"readonly": "readonly", "class": "form-control"}
            ),
        }


class LoginForm(forms.Form):
    username = forms.CharField(
        max_length=100,
        widget=forms.TextInput(
            attrs={"class": "form-control", "placeholder": "Kullanıcı Adı"}
        ),
    )
    password = forms.CharField(
        max_length=100,
        widget=forms.PasswordInput(
            attrs={"class": "form-control", "placeholder": "Şifre"}
        ),
    )
