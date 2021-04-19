FROM registry.access.redhat.com/ubi8/ubi-minimal

RUN microdnf --nodocs -y install openssh-server --enablerepo=rhel-8-for-x86_64-baseos-rpms && \
  microdnf clean all && \
  rm -rf /etc/pki/entitlement && \
  rm -rf /etc/rhsm

ADD sshd_config /opt/sftp/
ADD run /opt/sftp/

RUN useradd --no-user-group -u 11943 sftp-user && usermod -p "*" sftp-user && \
  mkdir /data && \
  mkdir -p /etc/ssh/sftp-user && \
  chown sftp-user:root /data && \
  chgrp -R 0 /etc/ssh/sftp-user /opt/sftp /data && \
  chmod g=u /etc/ssh/sftp-user /opt/sftp /data && \
  chmod 755 /etc/ssh/sftp-user 

VOLUME ["/data"]

EXPOSE 2222
  
USER 11943
ENTRYPOINT ["/opt/sftp/run"]
