FROM registry.access.redhat.com/ubi8/ubi-minimal

RUN microdnf --nodocs -y install openssh-server --enablerepo=rhel-8-for-x86_64-baseos-rpms && \
  microdnf clean all && \
  rm -rf /etc/pki/entitlement && \
  rm -rf /etc/rhsm

ADD sshd_config /opt/sftp/
ADD run /opt/sftp/

RUN useradd -u 11943 -U sftp-user && \
  usermod -g 0 -a -G 11943 sftp-user && \
  mkdir -p /etc/ssh/sftp-user && \
  chgrp -R 0 /etc/ssh/sftp-user /opt/sftp && \
  chmod g=u /etc/ssh/sftp-user /opt/sftp && \
  chmod 755 /etc/ssh/sftp-user 

EXPOSE 2222
  
USER 11943
ENTRYPOINT ["/opt/sftp/run"]
