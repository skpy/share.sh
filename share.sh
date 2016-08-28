#/bin/bash

usage() {
  cat << EOF
$0 [-d DIR] [-e] [-h] [-o OPTIONS] [-t TARGET] [-u URL]

 -d directory on server
 -e echo output, rather than call open
 -h help
 -o options to pass to rsync
 -t rsync target
 -u base URL for files

EOF
}

DIR=''
ECHO=0
OPTIONS=''
TARGET=''
URL=''

# if they have a config file, load it
if [ -f ${HOME}/.config/share.sh.conf ]; then
  source ${HOME}/.config/share.sh.conf
fi

while getopts “d:eho:t:u:” OPTION; do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    d)
      DIR=$OPTARG
      ;;
    e)
      # echo output
      ECHO=1
      ;;
    o)
      # rsync options
      OPTIONS=$OPTARG
      ;;
    t)
      # rsync server
      TARGET=$OPTARG
      ;;
    u)
      # url base
      URL=$OPTARG
      ;;
  esac
done
shift $(( OPTIND - 1 ))

if [ $# -eq 0 ]; then
  echo "No file specified! Aborting."
  exit 1
fi

if [ -z ${TARGET} ]; then
  echo "No upload target! Aborting."
  exit 1;
fi
if [ -z ${URL} ]; then
  echo "No URL provided! Aborting."
  exit 1;
fi

for FILE in "$@"
do
  # I want to suppress redundant directory separators in the
  # rsync command, and the resultant URL.
  DESTINATION=$(echo -n ${TARGET}/${DIR}/${FILE} | tr -s '/')
  LINK=$(echo -n ${URL}/${DIR}/${FILE} | tr -s '/' )
  echo rsync ${OPTIONS} ${FILE} ${DESTINATION};
  if [ $ECHO -eq 1 ]; then
    echo "${LINK}"
  else
    open "${LINK}"
  fi
done

