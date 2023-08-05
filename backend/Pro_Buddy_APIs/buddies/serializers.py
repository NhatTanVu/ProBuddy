from rest_framework import serializers
from .models import *
from users.serializers import GetUserDetailsSerializer


class BuddyGroupEventMemberSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroupEventMember
        fields = '__all__'


class ViewBuddyGroupEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroupEvent
        fields = ('id', 'name', 'description', 'start_date', 'end_date', 'location',
                  'is_finished', 'is_online', 'meeting_link', 'is_paid', 'fee',
                  'created_by', 'buddy_group', 'image')


class CreateBuddyGroupEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroupEvent
        fields = ('id', 'name', 'description', 'start_date',
                  'location', 'created_by', 'buddy_group', 'image')
        extra_kwargs = {'buddy_group': {'required': True},
                        'created_by': {'required': True}}


class CreateBuddyGroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroup
        fields = ('id', 'name', 'description', 'user', 'created_date', 'image')
        extra_kwargs = {'user': {'required': True}}


class BuddyGroupMemberSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroupMember
        fields = '__all__'


class ViewBuddyGroupSerializer(serializers.ModelSerializer):
    events = ViewBuddyGroupEventSerializer(many=True, read_only=True)
    user = GetUserDetailsSerializer(read_only=True)
    members = BuddyGroupMemberSerializer(many=True, read_only=True)

    class Meta:
        model = BuddyGroup
        fields = ('id', 'name', 'description',
                  'events', 'user', 'members', 'image')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        response["events"] = sorted(
            response["events"], key=lambda x: x["start_date"], reverse=True)
        return response


class CreateBuddyGroupEventMemberSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroupEventMember
        fields = '__all__'
        extra_kwargs = {'buddy_group_event': {'required': True},
                        'user': {'required': True}}


class CreateBuddyGroupMemberSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroupMember
        fields = '__all__'
        extra_kwargs = {'buddy_group': {'required': True},
                        'user': {'required': True}}
