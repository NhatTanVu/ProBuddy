from rest_framework import generics
from buddies.models import *
from buddies.serializers import *
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response


class CreateBuddyGroupAPIView(generics.CreateAPIView):
    queryset = BuddyGroup.objects.all()
    serializer_class = CreateBuddyGroupSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]


class ViewBuddyGroupsCreatedByUserIdAPIView(generics.ListAPIView):
    queryset = BuddyGroup.objects.all()
    serializer_class = ViewBuddyGroupSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        return BuddyGroup.objects.filter(user__id=user_id).order_by('-created_date')


class ViewBuddyGroupsJoinedByUserIdAPIView(generics.ListAPIView):
    queryset = BuddyGroup.objects.all()
    serializer_class = ViewBuddyGroupSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def list(self, request, *args, **kwargs):
        user_id = self.kwargs['user_id']
        buddy_group_ids = BuddyGroupMember.objects.filter(
            user__id=user_id).values_list('buddy_group__id', flat=True)
        queryset = BuddyGroup.objects.filter(
            id__in=buddy_group_ids).order_by('-created_date')
        serializer = ViewBuddyGroupSerializer(queryset, many=True)
        return Response(serializer.data)


class ViewBuddyGroupAPIView(generics.RetrieveAPIView):
    queryset = BuddyGroup.objects.all()
    serializer_class = ViewBuddyGroupSerializer
    lookup_field = 'id'
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]


class CreateBuddyGroupEventAPIView(generics.CreateAPIView):
    queryset = BuddyGroupEvent.objects.all()
    serializer_class = CreateBuddyGroupEventSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]


class RegisterBuddyGroupEventAPIView(generics.CreateAPIView):
    queryset = BuddyGroupEventMember.objects.all()
    serializer_class = CreateBuddyGroupEventMemberSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]