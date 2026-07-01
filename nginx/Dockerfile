FROM nginx:1.25-alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy React build into nginx's html directory
COPY ../frontend/build /usr/share/nginx/html

# Nginx config is mounted at runtime via docker-compose volume
EXPOSE 80 443
