from django.contrib import admin
from .models import *
from django.contrib.auth.admin import UserAdmin


class BeslemeKahramaniConfig(UserAdmin):
	search_fields = ('username', 'name', 'last_name', 'phone', 'email')
	ordering = ('-date_joined',)
	list_display = ('username', 'name', 'last_name', 'phone', 'email',
	                'is_staff', 'is_active', 'date_joined', 'date_last_login')
	fieldsets = (
		(None, {'fields': ('username', 'password')}),
		('Personal Info', {'fields': ('name', 'last_name',
		 'phone', 'email', 'profile_picture')}),
		('Permissions', {'fields': ('is_staff', 'is_active', 'is_superuser')}),
		('Dates', {'fields': ('date_joined', 'date_last_login')}),
		('Besleme Kahramani Info', {'fields': ('food_amount',)}),
	)
	readonly_fields = ('date_joined', 'date_last_login',
	                   'is_superuser', 'is_active')
	add_fieldsets = (
		(None, {
			'classes': ('wide',),
			'fields': ('username', 'name', 'last_name', 'phone', 'email',
			           'password1', 'password2', 'is_staff', 'is_active', 'is_superuser')
                }
   ),
	)


admin.site.register(BeslemeKahramani, BeslemeKahramaniConfig)
admin.site.register(FeedPoint)
