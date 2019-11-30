#!/bin/bash

# Created my own version of the script found here: https://www.dokuwiki.org/tips:offline-dokuwiki.sh

# default values
PROTO=http
DEPTH=2
ADDITIONNAL_WGET_OPTS=${AWO}
PROGNAME=${0##*/}

usage() {
   cat 1>&2 << EOT

NAME
   $PROGNAME: make an offline export of a dokuwiki documentation

SYNOPSIS
   $PROGNAME <options> hostname path/to/start

OPTIONS
   -u <username>   - The username if you need to authenticate
   -d <depth>      - How many levels to travers (default is 2)
   -h              - Show this help
   -s              - Uses https (default is http)
EOT
}

while getopts ":sd:u:h" opt; do
  case $opt in
    s)
      PROTO=https
      ;;
    d)
      DEPTH="$OPTARG"
      ;;
    u)
      ADDITIONNAL_WGET_OPTS="$ADDITIONNAL_WGET_OPTS --user=$OPTARG --ask-password"
      ;;
    h)
      usage
      exit 1
      ;;
    \?)
      # Unknown option
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      # Argument missing. The option expects an argument
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [[ "$#" -ne 2 ]]; then
  echo "Wrong number of arguments. Run with -h option for help"
  exit 1
fi

HOST="$1"
LOCATION="$2"

PREFIX="$(date +'%Y%m%d')-$HOST"

MY_INCLUDE_DIRS="wiki/_export/raw,wiki/lib,wiki/_media,${LOCATION}"

read -r -d '' REJECT << EOM
feed.php*,\
*do=backlink.html,\
*do=edit*,\
*do=index.html,\
*indexer.php?id=*,\
*do=admin.html,\
*do=revisions.html,\
*do=media*,\
*do=login*,\
*do=recent*,\
*do=register*,\
*do=profile*,\
*do=menuitem*,\
*do=subscribe*,\
*do=logout*,\
*do=diff*,\
*do=admin*,\
*?rev=*,\
*?idx=*,\
*?do=
EOM

echo "[WGET] downloading: start: $PROTO://$HOSTNAME/$LOCATION"
wget  --no-verbose \
      --recursive \
      --level="$DEPTH" \
      --execute robots=off \
      --page-requisites \
      --convert-links \
      --auth-no-challenge \
      --adjust-extension \
      --exclude-directories=_detail \
      --include-directories="${MY_INCLUDE_DIRS}" \
      --reject="$REJECT" \
      --directory-prefix="$PREFIX" \
      --no-host-directories \
      $ADDITIONNAL_WGET_OPTS \
      "$PROTO://$HOST/$LOCATION"

echo
echo "[SED] fixing links(href...) in the HTML sources"
sed -i -e 's#href="\([^:]\+:\)#href="./\1#g' \
       -e "s#\(indexmenu_\S\+\.config\.urlbase='\)[^']\+'#\1./'#" \
       -e "s#\(indexmenu_\S\+\.add('[^']\+\)#\1.html#" \
       -e "s#\(indexmenu_\S\+\.add([^,]\+,[^,]\+,[^,]\+,[^,]\+,'\)\([^']\+\)'#\1./\2.html'#" \
       ${PREFIX}/${LOCATION%/*}/*.html
