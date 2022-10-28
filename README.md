# cbwa_ca1

A very small Docker image (~154KB) to run any static website, based on the [BusyBox httpd](https://www.busybox.net/) static file server.

> If you're using the previous version (1.x, based on thttpd), I recommend upgrading since the new version (2.x) comes with a much smaller memory footprint.

## Usage

Code added to run CA1 from git respository:

dockerfile
RUN wget https://github.com/SuellenLourrayne/CA1/archive/refs/heads/main.tar.gz && tar xf master.tar.gz && rm master.tar.gz && mv /CA1-main /home/static

#copy the CA file
COPY --from=builder /home/static /home/static

## Changing working directory to /home/static/CA1-main
WORKDIR /home/static/CA1-main


Build the image:

sh
docker build -t cbwaca1 .


Run the image:

sh
docker run -it --rm -p 8080:8080 cbwaca1


Browse to `http://localhost:8080`.

If you need to configure the server in a different way, you can override the `CMD` line:

dockerfile

CMD ["/busybox", "httpd", "-f", "-v", "-p", "8080", "-c", "httpd.conf"]


### References 

Check out the [base source code](https://github.com/lipanski/docker-static-website).