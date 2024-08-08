#!/bin/bash

VERSION=BAP-1336

# needs configuration file
MEDIA_MOUNT="${S3_MEDIA_MOUNT:-/opt/data}"
MEDIA_PREFIX="${S3_MEDIA_PREFIX:-clear/data}"
MEDIA_BUCKET="${S3_MEDIA_BUCKET:-blob-storage-ingest}"

generate-json() {
  FILE=$1
  echo "{
     \"checksum\": \"$(get-sum $FILE)\",
     \"name\": \"$(get-name $FILE)\",
     \"size\": $(get-size $FILE),
     \"type\": \"$(get-type $FILE)\",
     \"bitrate\": $(get-bitrate $FILE),
     \"unit\": \"$(get-unit $FILE)\",
     \"creation\": \"$(get-creation $FILE)\",
     \"duration\": \"$(get-duration $FILE)\",
     \"metadata\": \"$(get-metadata $FILE)\",
     \"mime\": \"$(get-mime $FILE)\",
     \"project\": \"$(get-project $FILE)\",
     \"bucket\": \"$(get-bucket $FILE)\",
     \"key\": \"$(get-key $FILE)\"
}"
}

get-sum() {
  FILE=$1
  sha256sum $FILE | cut -f1 -d ' '
}

get-name() {
  FILE=$1
  echo $FILE | sed 's,.*/,,g '
}

get-size() {
  FILE=$1
  ls -l $FILE | awk '{print $5}' | sort -nr | head -1
}

get-mime() {
  FILE=$1
  file -b --mime $FILE
}

get-type() {
  FILE=$1
  basename $FILE | cut -f2 -d '.'
}

get-metadata() {
  FILE=$1
  file -b $FILE
}

get-project() {
  FILE=$1
  dirname $FILE | sed "s,^$MEDIA_MOUNT,,g;s,^[./]*,,g;s,//,/,g"
}

get-key() {
  FILE=$1
  echo $FILE | sed "s,^$MEDIA_MOUNT,$MEDIA_PREFIX,g;s,^[./]*,,g;s,//,/,g"
}

get-bucket() {
  echo $MEDIA_BUCKET
}

get-duration() {
  FILE=$1
  TYPE=$(get-type $FILE)

  case $TYPE in
    360|mp4|LRV)
      ffprobe $FILE 2>&1 | grep Duration | cut -f1 -d ',' | sed 's,^ *Duration: ,,g'
      ;;
    zip|png|py|jpg)
      echo "0"
      ;;
    *)
      echo "0"
      ;;
  esac

}

get-bitrate() {
  FILE=$1
  TYPE=$(get-type $FILE)

  case $TYPE in
    360|mp4|LRV)
      PROBE_LINE=$(ffprobe $FILE 2>&1 | grep Duration | cut -f3 -d ',' | cut -f2 -d ':' | awk '{print $1}')
      ret=$?
      if [ $ret -ne 0 ]; then
          echo -n 0
      else
          echo -n $PROBE_LINE
      fi
      ;;
    zip|png|py|jpg)
      echo -n 0
      ;;
    *)
      echo -n 0
      ;;
  esac

}

get-unit() {
  FILE=$1
  TYPE=$(get-type $FILE)

  case $TYPE in
    360|mp4|LRV)
      PROBE_LINE=$(ffprobe $FILE 2>&1 | grep Duration | cut -f3 -d ',' | cut -f2 -d ':' | awk '{print $2}' )
      ret=$?
      if [ $ret -ne 0 ]; then
        echo -n 0
      else
        echo -n $PROBE_LINE
      fi
      ;;
    zip|png|py|jpg)
      echo "byte"
      ;;
    *)
      echo -n "unknown"
      ;;
  esac

}

get-creation() {
  FILE=$1
  TYPE=$(get-type $FILE)

  case $TYPE in
    360|mp4|LRV)
      PROBE_LINE=$(ffprobe $FILE 2>&1 | grep creation_time | head -1 | awk '{print $3}' )
      ret=$?
      if [ $ret -ne 0 ]; then
        echo -n 0
      else
        echo -n $PROBE_LINE
      fi
      ;;
    *)
      ls -l --time-style="+%Y-%m-%dT%H:%M:%M.000000Z" $FILE | awk '{print $6}' | sort -nr | head -1
      ;;
  esac

}

version() {
  echo ${VERSION}
}

main() {
  MEDIA_FILE=$1
  generate-json $MEDIA_FILE
}

main $*
