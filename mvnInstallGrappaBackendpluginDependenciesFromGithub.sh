#!/bin/bash

set -e # exit on first error

MVNOPTS=""
CURLOPTS=""
VERBOSE="1"
GBPLIBVER=0.3.0
TMPDIR=/tmp

unameOut="$(uname -s)"
case "${unameOut}" in
    CYGWIN*)    TMPDIRWIN=`cygpath -w ${TMPDIR}`;;
    *)          TMPDIRWIN=${TMPDIR}
esac


while getopts 'qr:h' opt; do
  case "$opt" in
    q)
      MVNOPTS="-q"
      CURLOPTS="-s"
      VERBOSE="0"
      ;;

    r)
      arg="$OPTARG"
      GBPLIBVER=${OPTARG}
      ;;
   
    ?|h)
      echo "This script downloads a grappa-backendplugin java library release from"
      echo "github and installs it to your local maven repository."
      echo "All releases can be found here:"
      echo "  https://github.com/hsh-elc/grappa-backendplugin/releases"
      echo ""
      echo "Usage: $(basename $0) [-q] [-r release]"
      echo "  -h            help"
      echo "  -q            quiet"
      echo "  -r release    select release. Default release is $GBPLIBVER"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"



declare -a arrayGBPDownloads=(\
  grappa-backendplugin-${GBPLIBVER}.pom \
  grappa-backendplugin-${GBPLIBVER}.jar  \
)


# Working directory:
WDIR="$TMPDIR/mvnInstallGrappaBackendpluginDependenciesFromGithub"
mkdir -p "$WDIR"
WDIRWIN="$TMPDIRWIN/mvnInstallGrappaBackendpluginDependenciesFromGithub"


echoline() {
    local text=$1
    if [ $VERBOSE -ne 0 ]; then
        echo "-------------------------------------------------------------------------------------"
        echo $text
        echo "-------------------------------------------------------------------------------------"
    fi
}

download() {
    local file=$1
    local url=$2
    echoline "   downloading from $url to $WDIR/$file"
    wget $CURLOPTS --retry-connrefused --retry-on-http-error=503,429 \
        -O "$WDIR/$file" \
        $url
}

downloadGBP() {
    local file=$1
    local url="https://github.com/hsh-elc/grappa-backendplugin/releases/download/v${GBPLIBVER}/$file"
    download "$file" "$url"
}

downloadProforma() {
    local file=$1
    local url="https://github.com/hsh-elc/proforma/releases/download/v${PFLIBVER}/$file"
    download "$file" "$url"
}

deploy() {
    local file=$1
    echoline "   mvn install $file"

    extension="${file##*.}"
    filename="${file%.*}"

    mvn $MVNOPTS install:install-file \
      -Dfile="$WDIRWIN/$file" \
      -DpomFile="$WDIRWIN/$filename.pom" 
}




for i in "${arrayGBPDownloads[@]}"
do
    downloadGBP "$i"
    deploy "$i"
done


PFLIBVER=`mvn dependency:tree "-Dincludes=proforma:*:*:*" -f $WDIRWIN/grappa-backendplugin-${GBPLIBVER}.pom | grep "proforma:proformautil" | sed -e "s#^.*:\(.*\):compile#\1#g" | tr -d '\r\n'`

echoline "Downloading proforma libs version $PFLIBVER"

declare -a arrayProformaDownloads=(\
  proforma-${PFLIBVER}.pom \
  proformaxml-${PFLIBVER}.pom \
  proformaxml-2-1-${PFLIBVER}.pom  \
  proformautil-${PFLIBVER}.pom  \
  proformautil-2-1-${PFLIBVER}.pom  \
  proformaxml-${PFLIBVER}.jar \
  proformaxml-2-1-${PFLIBVER}.jar  \
  proformautil-${PFLIBVER}.jar  \
  proformautil-2-1-${PFLIBVER}.jar  \
)


for i in "${arrayProformaDownloads[@]}"
do
    downloadProforma "$i"
    deploy "$i"
done


# cleanup
if [ -d "$WDIR" ]; then
  rm -rf $WDIR
fi
