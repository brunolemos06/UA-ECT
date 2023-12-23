reg_port=5000

#auth_backend
cd auth/
docker buildx build --platform linux/amd64 --network=host -t registry.deti:$reg_port/egs-ridemate/auth_backend:v2 .

#auth_frontend
cd frontend/
docker buildx build --platform linux/amd64 --network=host -t registry.deti:$reg_port/egs-ridemate/auth_frontend:v2 .

#chat_api
cd ../../chat_api/
docker buildx build --platform linux/amd64 --network=host -t registry.deti:$reg_port/egs-ridemate/chat_api:v1 .

#composer
cd ../composer/
docker buildx build --platform linux/amd64 --network=host -t registry.deti:$reg_port/egs-ridemate/composer:v6 .

#payments
cd ../payments/
docker buildx build --platform linux/amd64 --network=host -t registry.deti:$reg_port/egs-ridemate/payments:v2 .

#reviews
cd ../review/
docker buildx build --platform linux/amd64 --network=host -t registry.deti:$reg_port/egs-ridemate/reviews:v1 .

#trip
cd ../trip/
docker buildx build --platform linux/amd64 --network=host -t registry.deti:$reg_port/egs-ridemate/trip:v2 .