FROM alpine:3.20

# busybox-extras brings telnetd; the base image already has login/passwd
RUN apk add --no-cache busybox-extras \
 && adduser -D -s /bin/sh operator \
 && echo 'operator:operator' | chpasswd \
 && touch /run/utmp

COPY motd /etc/motd
COPY operator/ /home/operator/
RUN chown -R operator:operator /home/operator

EXPOSE 23
CMD ["telnetd", "-F", "-l", "/bin/login"]
