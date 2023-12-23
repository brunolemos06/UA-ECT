from django.urls import path
from . import views
from django.views.decorators.csrf import csrf_exempt

urlpatterns = [
    path('trip/', csrf_exempt(views.TripView.as_view()), name='directions-trip'),
    path('owner/', csrf_exempt(views.OwnerView.as_view()), name='directions-owner'),
    path('participant/', csrf_exempt(views.ParticipantView.as_view()), name='directions-participants'),
    # path('user/', csrf_exempt(views.UserView.as_view()), name='directions-user'),
    # path('trip/', csrf_exempt(views.trip), name='directions-trip'),
    # path('user/', csrf_exempt(views.post_trip), name='directions-post-trip')
]

