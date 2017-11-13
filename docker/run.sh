#!/bin/bash

. /opt/predictionio/conf/pio-env.sh

RET=-1
COUNT=0
ES_HOST=`echo $PIO_STORAGE_SOURCES_ELASTICSEARCH_HOSTS | sed -e "s/,.*//"`
# Wait for elasticsearch startup
while [ $RET != 0 -a $COUNT -lt 10 ] ; do
  echo "Waiting for ${ES_HOST}..."
  curl --connect-timeout 60 --retry 10 -s "$ES_HOST:9200/_cluster/health?wait_for_status=yellow&timeout=1m"
  RET=$?
  COUNT=`expr $COUNT + 1`
  sleep 1
done

# Check PIO status
pio status

if [ -f /work/run.sh ] ; then
  /bin/bash /work/run.sh
else
  echo "No run script."
  /bin/bash
fi

