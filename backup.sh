#!/bin/bash

# Get timestamp
: ${BACKUP_SUFFIX:=.$(date +"%Y-%m-%d-%H-%M-%S")}
readonly tarball=$BACKUP_NAME$BACKUP_SUFFIX.tar.gz

# Create a gzip compressed tarball with the volume(s)
tar czf $tarball $BACKUP_TAR_OPTION $PATHS_TO_BACKUP

if [ -n "$GPG_PUBLIC_KEY" ]; then

  # Write private key to file
  echo $GPG_PUBLIC_KEY > /public.key

  # Import private key
  gpg  --import /tmp/public.key

  # Delete temporary file
  rm /tmp/public.key

  # Encrypt backup
  gpg --output $tarball --encrypt --recipient $GPG_KEY_NAME $tarball
fi

# Create bucket, if it doesn't already exist
BUCKET_EXIST=$(aws s3 ls | grep $S3_BUCKET_NAME | wc -l)
if [ $BUCKET_EXIST -eq 0 ];
then
  aws s3 mb s3://$S3_BUCKET_NAME
fi

# Upload the backup to S3 with timestamp
aws s3 --region $AWS_DEFAULT_REGION cp $tarball s3://$S3_BUCKET_NAME/$tarball
