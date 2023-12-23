from django.urls import path, include, re_path
from . import views

urlpatterns = [
    path('paypal/create/order', views.CreateOrderViewRemote.as_view(), name='ordercreate'),
    path('paypal/capture/order', views.CaptureOrderView.as_view(), name='captureorder'),
]