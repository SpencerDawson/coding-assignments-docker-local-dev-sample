FROM nginx:stable-alpine

## Copy and Update certificates 
# COPY ./sample-cert.crt /usr/local/share/ca-certificates/sample-cert.crt
# RUN cat /usr/local/share/ca-certificates/sample-cert.crt >> /etc/ssl/certs/ca-certificates.crt &&\
#     /usr/sbin/update-ca-certificates 

CMD ["nginx", "-g", "daemon off;"]