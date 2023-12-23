#!/bin/bash

repository_tags=(
  "registry.deti:5000/egs-ridemate/composer:v6"
  "registry.deti:5000/egs-ridemate/chat_api:v1"
  "registry.deti:5000/egs-ridemate/reviews:v1"
  "registry.deti:5000/egs-ridemate/trip:v2"
  "registry.deti:5000/egs-ridemate/auth_backend:v2"
  "registry.deti:5000/egs-ridemate/payments:v2"
  "registry.deti:5000/egs-ridemate/auth_frontend:v2"
)

# Remove Docker images
for repository_tag in "${repository_tags[@]}"; do
  docker rmi "$repository_tag"
done
