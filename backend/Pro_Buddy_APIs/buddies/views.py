from rest_framework import generics
from buddies.models import *
from buddies.serializers import *
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status


class CreateBuddyGroupAPIView(generics.CreateAPIView):
    queryset = BuddyGroup.objects.all()
    serializer_class = CreateBuddyGroupSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        name = request.data.get('name')
        description = request.data.get('description')
        user_id = request.data.get('user')
        image = request.FILES.get('image')

        if name and description and user_id:
            if image:
                new_group = BuddyGroup.objects.create(
                    image=image, name=name, description=description, user_id=user_id)
            else:
                new_group = BuddyGroup.objects.create(
                    name=name, description=description, user_id=user_id)
            serializer = CreateBuddyGroupSerializer(new_group)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)


class DeleteBuddyGroupAPIView(generics.DestroyAPIView):
    queryset = BuddyGroup.objects.all()
    serializer_class = ViewBuddyGroupSerializer
    lookup_field = 'id'
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
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def list(self, request, *args, **kwargs):
        user_id = self.kwargs['user_id']
        buddy_group_ids = BuddyGroupMember.objects.filter(
            user__id=user_id).values_list('buddy_group__id', flat=True)
        queryset = BuddyGroup.objects.filter(
            id__in=buddy_group_ids).order_by('-created_date')
        serializer = ViewBuddyGroupSerializer(queryset, many=True,
                                              context={'request': request})
        return Response(serializer.data)


class ViewBuddyGroupAPIView(generics.RetrieveAPIView):
    queryset = BuddyGroup.objects.all()
    serializer_class = ViewBuddyGroupSerializer
    lookup_field = 'id'
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]


class JoinBuddyGroupAPIView(generics.CreateAPIView):
    queryset = BuddyGroupMember.objects.all()
    serializer_class = CreateBuddyGroupMemberSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]


class LeaveBuddyGroupAPIView(generics.DestroyAPIView):
    permission_classes = (IsAuthenticated,)

    def delete(self, request, *args, **kwargs):
        buddy_group_id = request.data.get('buddy_group')
        user_id = request.data.get('user')

        if buddy_group_id is None:
            return Response({"detail": "buddy_group is required."}, status=status.HTTP_400_BAD_REQUEST)
        if user_id is None:
            return Response({"detail": "user_id is required."}, status=status.HTTP_400_BAD_REQUEST)

        BuddyGroupMember.objects.filter(
            user_id=user_id, buddy_group_id=buddy_group_id).delete()
        return Response({"detail": "Successfully left the group."}, status=status.HTTP_200_OK)


class CreateBuddyGroupEventAPIView(generics.CreateAPIView):
    queryset = BuddyGroupEvent.objects.all()
    serializer_class = CreateBuddyGroupEventSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        name = request.data.get('name')
        description = request.data.get('description')
        start_date = request.data.get('start_date')
        location = request.data.get('location')
        created_by = request.data.get('created_by')
        buddy_group = request.data.get('buddy_group')
        image = request.FILES.get('image')

        if buddy_group and created_by:
            if image:
                new_group = BuddyGroupEvent.objects.create(
                    image=image, name=name, description=description, start_date=start_date, location=location, created_by_id=created_by, buddy_group_id=buddy_group)
            else:
                new_group = BuddyGroupEvent.objects.create(
                    name=name, description=description, start_date=start_date, location=location, created_by_id=created_by, buddy_group_id=buddy_group)
            serializer = CreateBuddyGroupEventSerializer(new_group)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)


class RegisterBuddyGroupEventAPIView(generics.CreateAPIView):
    queryset = BuddyGroupEventMember.objects.all()
    serializer_class = CreateBuddyGroupEventMemberSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]


class UnregisterBuddyGroupEventAPIView(generics.DestroyAPIView):
    permission_classes = (IsAuthenticated,)

    def delete(self, request, *args, **kwargs):
        buddy_group_event_id = request.data.get('buddy_group_event')
        user_id = request.data.get('user')

        if buddy_group_event_id is None:
            return Response({"detail": "buddy_group_event is required."}, status=status.HTTP_400_BAD_REQUEST)
        if user_id is None:
            return Response({"detail": "user_id is required."}, status=status.HTTP_400_BAD_REQUEST)

        BuddyGroupEventMember.objects.filter(
            user_id=user_id, buddy_group_event_id=buddy_group_event_id).delete()
        return Response({"detail": "Successfully unregistered from the event."}, status=status.HTTP_200_OK)


class DeleteBuddyGroupEventAPIView(generics.DestroyAPIView):
    queryset = BuddyGroupEvent.objects.all()
    serializer_class = CreateBuddyGroupEventSerializer
    lookup_field = 'id'
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]


class ViewBuddyGroupEventMembersByEventIdAPIView(generics.ListAPIView):
    queryset = BuddyGroupEventMember.objects.all()
    serializer_class = BuddyGroupEventMemberSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        event_id = self.kwargs['event_id']
        return BuddyGroupEventMember.objects.filter(buddy_group_event__id=event_id)


class ViewBuddyGroupEventsJoinedByUserIdAPIView(generics.ListAPIView):
    queryset = BuddyGroupEvent.objects.all()
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def list(self, request, *args, **kwargs):
        user_id = self.kwargs['user_id']
        buddy_group_event_ids = BuddyGroupEventMember.objects.filter(
            user__id=user_id).values_list('buddy_group_event__id', flat=True)
        queryset = BuddyGroupEvent.objects.filter(
            id__in=buddy_group_event_ids).order_by('start_date')
        serializer = ViewBuddyGroupEventSerializer(queryset, many=True,
                                                   context={'request': request})
        return Response(serializer.data)


class ViewAllBuddyGroupsAPIView(generics.ListAPIView):
    queryset = BuddyGroup.objects.all()
    serializer_class = ViewBuddyGroupSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]
