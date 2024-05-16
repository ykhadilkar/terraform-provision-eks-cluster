#!/bin/bash
set -e

#update admin password
CREDS='-u root -p superSecret'

# Force file syncronization and lock writes
mongosh ${CREDS} admin --eval "printjson(db.fsyncLock())"

MONGO_DATABASE="admin" #replace with your database name

TIMESTAMP=`date +%F-%H%M%S`
S3_BUCKET_NAME="yatin-mongodb-backup" #replace with your bucket name on Amazon S3
S3_BUCKET_PATH="mongodb-backups"

# Create backup
mongodump --authenticationDatabase admin ${CREDS} -d $MONGO_DATABASE

# Add timestamp to backup
mv dump mongodb-dump-$HOSTNAME-$TIMESTAMP
tar cf mongodb-dump-$HOSTNAME-$TIMESTAMP.tar mongodb-dump-$HOSTNAME-$TIMESTAMP

# Upload to S3
aws s3 cp mongodb-dump-$HOSTNAME-$TIMESTAMP.tar s3://$S3_BUCKET_NAME/$S3_BUCKET_PATH/mongodb-dump-$HOSTNAME-$TIMESTAMP.tar

#Unlock database writes
mongosh ${CREDS} admin --eval "printjson(db.fsyncUnlock())" 

#Delete local files
rm -rf mongodb-dump-$HOSTNAME-$TIMESTAMP*