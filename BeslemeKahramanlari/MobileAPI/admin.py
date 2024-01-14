from django.contrib import admin
from .models import *
from django.contrib.auth.admin import UserAdmin


class BeslemeKahramaniConfig(UserAdmin):
    search_fields = ("username", "name", "last_name", "email")
    ordering = ("-date_joined",)
    list_display = (
        "username",
        "name",
        "last_name",
        "email",
        "is_staff",
        "is_active",
        "date_joined",
        "date_last_login",
    )
    fieldsets = (
        (None, {"fields": ("username", "password")}),
        ("Personal Info", {"fields": ("name", "last_name", "email")}),
        ("Permissions", {"fields": ("is_staff", "is_active", "is_superuser")}),
        ("Dates", {"fields": ("date_joined", "date_last_login")}),
        ("Besleme Kahramani Info", {"fields": ("food_amount",)}),
    )
    readonly_fields = ("date_joined", "date_last_login", "is_superuser", "is_active")
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "username",
                    "name",
                    "last_name",
                    "email",
                    "password1",
                    "password2",
                    "is_staff",
                    "is_active",
                    "is_superuser",
                ),
            },
        ),
    )


class FeedPointConfig(admin.ModelAdmin):
    def change_view(self, *args, **kwargs):
        self.readonly_fields = (
            "food_amount",
            "food_level",
            "food_avarage_amount",
            "last_calculated_at",
            "should_update",
        )
        self.calculate_food_level(kwargs["object_id"])
        return super(FeedPointConfig, self).change_view(*args, **kwargs)

    def calculate_food_level(self, object_id):
        feed_point = FeedPoint.objects.get(pk=object_id)
        feed_point.calculate_food_level()


admin.site.register(BeslemeKahramani, BeslemeKahramaniConfig)
admin.site.register(FeedPoint, FeedPointConfig)
admin.site.register(Post)
admin.site.register(Report)
