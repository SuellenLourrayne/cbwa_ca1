FROM alpine:3.16.2 AS builder

# Install all dependencies required for compiling busybox
RUN apk add gcc musl-dev make perl

# Downloading the busybox sources
RUN wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2 \
  && tar xf busybox-1.35.0.tar.bz2 \
  && mv /busybox-1.35.0 /busybox

# Create a non-root user to own the files and run our server
RUN adduser -D static 

# Download WebDevelopment CA1 sources
RUN wget https://github.com/SuellenLourrayne/CA1/archive/refs/heads/main.tar.gz && tar xf main.tar.gz \
  && rm main.tar.gz \
  && mv /CA1-main /home/static  

WORKDIR /busybox

# Copy the busybox build config (limited to httpd)
COPY .config .
RUN make && make install

# Switch to the scratch image
FROM scratch

EXPOSE 8080

# Copy over the user
COPY --from=builder /etc/passwd /etc/passwd

# Copy the busybox static binary
COPY --from=builder /busybox/_install/bin/busybox /

#copy the CA file
COPY --from=builder /home/static /home/static

# Use our non-root user
USER static
WORKDIR /home/static

#Changing work directory
WORKDIR /home/static/CA1-main

# Uploads a blank default httpd.conf
# This is only needed in order to set the `-c` argument in this base file
# and save the developer the need to override the CMD line in case they ever
# want to use a httpd.conf
COPY httpd.conf .

# Run busybox httpd
CMD ["/busybox", "httpd", "-f", "-v", "-p", "8080", "-c", "httpd.conf"]