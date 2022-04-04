# Base is NGINX
FROM nginx:stable

# Expose HTTP
EXPOSE 80

# copy the spectral file as the default index
COPY spectral.html /usr/share/nginx/html/index.html

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
