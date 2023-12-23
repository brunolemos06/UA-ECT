from rest_framework import serializers
from .models import payments

class paymentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = payments
        fields = '__all__'

        def save(self):
            return payments.objects.create(**self.validated_data)