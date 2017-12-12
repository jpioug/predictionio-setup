#!/bin/bash

. /opt/predictionio/conf/pio-env.sh

RET=-1
COUNT=0
ES_HOST=`echo $PIO_STORAGE_SOURCES_ELASTICSEARCH_HOSTS | sed -e "s/,.*//"`
# Wait for elasticsearch startup
while [ $RET != 0 -a $COUNT -lt 60 ] ; do
  echo "[PIO-SETUP] Waiting for ${ES_HOST}..."
  curl --connect-timeout 60 --retry 10 -s "$ES_HOST:9200/_cluster/health?wait_for_status=green&timeout=1m"
  RET=$?
  COUNT=`expr $COUNT + 1`
  sleep 1
done

RUN_FILE=/work/run.sh
if [ -f $RUN_FILE ] ; then
  # Change uid for PIO_USER
  USERID=`ls -ln $RUN_FILE | awk '{print $3}'`
  echo "[PIO-SETUP] Script File User: $USERID from "`ls -ln $RUN_FILE`
  if [ x"$USERID" != "x" -a x"$USERID" != "x0" ] ; then
    echo "[PIO-SETUP] Updating uid for $PIO_USER to $USERID"
    usermod -u $USERID $PIO_USER
  else
    export PIO_USER=root
  fi

  echo "[PIO-SETUP] User Info: "`id $PIO_USER`
  chown -R $PIO_USER /opt/predictionio /opt/spark

  # Check PIO status
  sudo -i -u $PIO_USER /opt/predictionio/bin/pio status
  if [ $? != 0 ] ; then
    echo "[PIO-SETUP] PredictionIO is not available."
  fi
  # Start PIO Event Server
  sudo -i -u $PIO_USER /opt/predictionio/bin/pio eventserver &

  echo "[PIO-SETUP] Running $RUN_FILE"
  /bin/bash $RUN_FILE
else
  echo "[PIO-SETUP] No run script."
fi

