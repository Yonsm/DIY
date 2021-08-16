#!/bin/sh
if [[ "${QUERY_STRING/v=1//}" != "$QUERY_STRING" ]]; then
	MIME_TYPE=video/mp4
else
	MIME_TYPE=image/jpeg
fi

REC_DIR=/mnt/media/mmcblk0p1/MIJIA_RECORD_VIDEO
LAST_PATH=`ls -1d $REC_DIR/*/ | tail -1`
LAST_DIR=`basename $LAST_PATH`
LAST_FILE=`ls -1 $REC_DIR/$LAST_DIR/*.${MIME_TYPE##*/} | tail -1`

if [[ "${QUERY_STRING/r=1//}" != "$QUERY_STRING" ]]; then
	echo "Location: /record/$LAST_DIR/${LAST_FILE##*/}"
	echo
	exit
fi

echo "Content-type: $MIME_TYPE"
echo "Content-Length: $(wc -c < $LAST_FILE)"
echo "Content-Transfer-Encoding: binary"
#echo "Content-Disposition: filename=${LAST_FILE##*/}"

echo
cat $LAST_FILE
