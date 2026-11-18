# Local stand-in for the phone, used only by ops/deploy/test/test-deploy.ps1.
# Same package line as the phone (Alpine edge), SSH with key login only, Node.js 24.
FROM alpine:edge
RUN apk add --no-cache openssh-server nodejs \
 && adduser -D -s /bin/sh deploy \
 && echo 'deploy:*' | chpasswd -e \
 && ssh-keygen -A \
 && printf 'PasswordAuthentication no\nKbdInteractiveAuthentication no\nPermitRootLogin no\n' > /etc/ssh/sshd_config.d/test.conf
COPY entrypoint.sh /entrypoint.sh
EXPOSE 22
ENTRYPOINT ["sh", "/entrypoint.sh"]
