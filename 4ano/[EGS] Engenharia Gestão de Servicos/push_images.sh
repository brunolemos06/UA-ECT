reg_port=5000
docker push registry.deti:$reg_port/egs-ridemate/auth_backend:v2
docker push registry.deti:$reg_port/egs-ridemate/auth_frontend:v2
docker push registry.deti:$reg_port/egs-ridemate/chat_api:v1
docker push registry.deti:$reg_port/egs-ridemate/composer:v6
docker push registry.deti:$reg_port/egs-ridemate/payments:v2
docker push registry.deti:$reg_port/egs-ridemate/reviews:v1
docker push registry.deti:$reg_port/egs-ridemate/trip:v2