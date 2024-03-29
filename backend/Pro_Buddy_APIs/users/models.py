from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    GENDER_CHOICES = (
        ('M', 'Male'),
        ('F', 'Female'),
        ('O', 'Other')
    )

    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.EmailField(unique=True)
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES)
    date_of_birth = models.DateField()
    address = models.CharField(max_length=255)
    image = models.ImageField(upload_to='images/', null=True, blank=True)


class UserInterest(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='interests')
    name = models.CharField(max_length=255)


class UserService(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='services')
    name = models.CharField(max_length=255)


class UserChat(models.Model):
    created_date = models.DateTimeField()
    from_user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='from_user')
    to_user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='to_user')
    message = models.CharField(max_length=255)
    