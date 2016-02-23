#!/bin/bash

# Find last backup file
: ${LAST_BACKUP:=$(aws s3 ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}' | grep ^$BACKUP_NAME | sort -r | head -n1)}

# Download backup from S3
aws s3 cp s3://$S3_BUCKET_NAME/$LAST_BACKUP $LAST_BACKUP

if [ -n "$GPG_PRIVATE_KEY" ]; then

  # Write private key to file
  echo $GPG_PRIVATE_KEY > /private.key

  # Import private key
  gpg --allow-secret-key-import --import /tmp/private.key

  # Delete temporary file
  rm /tmp/private.key

  # Decrypt backup
  gpg --output $LAST_BACKUP --decrypt $LAST_BACKUP
fi

# Extract backup
tar xzf $LAST_BACKUP $RESTORE_TAR_OPTION
