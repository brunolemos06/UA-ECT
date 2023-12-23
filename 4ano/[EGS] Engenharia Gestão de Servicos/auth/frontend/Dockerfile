# # Use an official Node.js runtime as the base image
# FROM node:14-alpine

# # Set the working directory inside the container
# WORKDIR /auth_frontend

# # Copy the package.json and package-lock.json (or yarn.lock) files to the container
# COPY package*.json ./
# ADD package.json /usr/src/app/package.json

# # Install project dependencies
# RUN npm install

# # Copy the entire project directory to the container
# COPY . .

# # Build the React application
# RUN npm run build

# # Set the environment variable to serve the static files
# ENV NODE_ENV=production

# # Expose the port on which your React application will run (default is 3000)
# EXPOSE 3000

# # Define the command to start your application
# CMD ["npm", "start"]

#----------------------------------------------
# Base image
FROM node:14.17.0-alpine as build

# Set working directory
WORKDIR /auth_frontend

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project
COPY . .

# Build the React app
RUN npm run build

# Production-ready image
FROM nginx:1.21.1-alpine

# Copy built files from the build stage to the NGINX directory
COPY --from=build /auth_frontend/build /usr/share/nginx/html

# Copy the default NGINX configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 3000
EXPOSE 3000

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
