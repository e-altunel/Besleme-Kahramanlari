# Generated by Django 4.2.6 on 2023-12-03 11:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('MobileAPI', '0003_alter_beslemekahramani_phone'),
    ]

    operations = [
        migrations.AlterField(
            model_name='beslemekahramani',
            name='is_superuser',
            field=models.BooleanField(default=False),
        ),
    ]