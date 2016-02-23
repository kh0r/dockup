FROM ubuntu:trusty
MAINTAINER Borja Burgos <borja@tutum.co>, Mia Iversen <mia@chillfox.com

RUN apt-get update && apt-get install -y python-pip gpg && pip install awscli

ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

ENV S3_BUCKET_NAME docker-backups.example.com
ENV AWS_ACCESS_KEY_ID **DefineMe**
ENV AWS_SECRET_ACCESS_KEY **DefineMe**
ENV AWS_DEFAULT_REGION us-east-1
ENV PATHS_TO_BACKUP /paths/to/backup
ENV BACKUP_NAME backup
ENV GPG_KEY_NAME **DefineMe**
ENV GPG_PUBLIC_KEY **DefineMe**
ENV GPG_PRIVATE_KEY **DefineMe**
ENV RESTORE false

CMD ["/run.sh"]
