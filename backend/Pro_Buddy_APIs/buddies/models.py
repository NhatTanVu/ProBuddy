from django.db import models
from users.models import User

class Buddy(models.Model):
    created_date = models.DateTimeField(auto_now_add=True)
    user1 = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='buddies_1')
    user2 = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='buddies_2')


class BuddyGroup(models.Model):
    created_date = models.DateTimeField(auto_now_add=True)
    name = models.CharField(max_length=150)
    description = models.CharField(max_length=255)
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='buddy_groups', null=False, blank=False)
    image = models.ImageField(upload_to='images/', null=True, blank=True)
    

class BuddyGroupMember(models.Model):
    buddy_group = models.ForeignKey(
        BuddyGroup, on_delete=models.CASCADE, related_name='members')
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='buddy_group_members')
    

class BuddyGroupEvent(models.Model):
    buddy_group = models.ForeignKey(
        BuddyGroup, on_delete=models.CASCADE, related_name='events')
    name = models.CharField(max_length=150)
    description = models.CharField(max_length=255)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField(null=True, blank=True)
    location = models.CharField(max_length=255)
    created_date = models.DateTimeField(auto_now_add=True)
    created_by = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='buddy_group_events')
    is_finished = models.BooleanField(default=False)
    is_online = models.BooleanField(default=False)
    meeting_link = models.CharField(max_length=255)
    is_paid = models.BooleanField(default=False)
    fee = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    image = models.ImageField(upload_to='images/', null=True, blank=True)


class BuddyGroupEventMember(models.Model):
    buddy_group_event = models.ForeignKey(
        BuddyGroupEvent, on_delete=models.CASCADE, related_name='buddy_group_events')
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='buddy_group_event_members')
    registered_date = models.DateTimeField(auto_now_add=True)
    is_joined = models.BooleanField(default=False)
    is_paid = models.BooleanField(default=False)
    paid_date = models.DateTimeField(null=True, blank=True)
    paid_amount = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)


class BuddyGroupEventReview(models.Model):
    buddy_group_event = models.ForeignKey(
        BuddyGroupEvent, on_delete=models.CASCADE, related_name='reviews')
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='buddy_group_event_reviews')
    created_date = models.DateTimeField(auto_now_add=True)
    rating = models.IntegerField()
    comment = models.CharField(max_length=255)
    reply_review = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True)