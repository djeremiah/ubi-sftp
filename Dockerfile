FROM registry.access.redhat.com/ubi8/ubi-minimal

RUN microdnf --nodocs -y install openssh-server --enablerepo=rhel-8-for-x86_64-baseos-rpms && \
  microdnf clean all

ADD authorized_keys /etc/ssh/sftp-user/
ADD sshd_config /opt/sftp/
ADD run /opt/sftp/

RUN useradd --no-user-group -u 11943 sftp-user && usermod -p "*" sftp-user && \
  chgrp -R 0 /etc/ssh/sftp-user /opt/sftp && \
  chmod g=u /etc/ssh/sftp-user /opt/sftp && \
  chmod 755 /etc/ssh/sftp-user && \
  chmod 644 /etc/ssh/sftp-user/authorized_keys

VOLUME ["/data"]

EXPOSE 2222
  
USER 11943
ENTRYPOINT ["/opt/sftp/run"]
