#!/bin/bash
set -x

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

function clean {
  [ -d $DIR/$1 ] && $( cd $DIR/$1; make clean ) && cd $DIR
}

function dirclean {
  [ -d $DIR/$1 ] && $( cd $DIR/$1; make dirclean )  && cd $DIR
}

declare -A urls
urls["cc"]="https://git.openwrt.org/15.05/openwrt.git"
urls["dd"]="https://git.openwrt.org/openwrt.git"
urls["lede"]="https://git.lede-project.org/source.git"

MODEL=$1

VERSION=$2
ACTION="${3:-build}"


function exists_in_urls  {
    # If the given key maps to a non-empty string (-n), the
    # key obviously exists. Otherwise, we need to check if
    # the special expansion produces an empty string or an
    # arbitrary non-empty string.
    [[ -n ${urls[$1]} || -z ${urls[$1]-foo} ]]
}

function exists_in_models {
  [[ -d $DIR/$1 ]]
}

#check if version is valid
if !  exists_in_urls $VERSION ; then
  echo "There is no ${VERSION}"
  exit 1;
fi

if ! exists_in_models $MODEL ; then
  echo "There is no ${MODEL}"
  exit 2;
fi

function prepare_build {
 MODEL=$1
 VERSION=$2
 GIT_REPO=$3
 (
 cd $DIR/$MODEL
 git -C $VERSION.build pull --ff-only || git clone $GIT_REPO $VERSION.build
 rm $VERSION.build/feeds.conf
 echo "src-link boardcoop $DIR/$MODEL/$VERSION-feed"|cat - $VERSION.feeds.conf > /tmp/out && mv /tmp/out $VERSION.build/feeds.conf
 rm $VERSION.build/.config
 cp $VERSION.config $VERSION.build/.config
 cd $VERSION.build
 scripts/feeds update
 scripts/feeds install -a
 make defconfig
 cp -f ../$VERSION.config .config
 make defconfig
 )
 wait
}

function run_build {
  MODEL=$1
  VERSION=$2
  GIT_REPO=$3
  #ACTION= $4
  #[ "$ACTION" == "clean" ] && clean $VERSION.build
  #[ "$ACTION" == "dirclean" ] && dirclean $VERSION.build
  prepare_build $MODEL $VERSION $GIT_REPO
  (
    cd $DIR/$MODEL/$VERSION.build
    make
  )
  wait
}

function run_update {
  (
  cd $DIR/$1/$2.build
  scripts/diffconfig.sh > $DIR/$1/$2.config

  )
  wait
}

function menuconf {
  (
    cd $DIR/$1/$2.build
    make menuconfig
  )
  wait
}


if [ "$ACTION" == "build" ]; then
  run_build $MODEL $VERSION ${urls[$VERSION]}
elif [ "$ACTION" == "update" ]; then
  run_update $MODEL $VERSION
elif [ "$ACTION" == "prepare" ]; then
  prepare_build $MODEL $VERSION ${urls[$VERSION]}
elif [ "$ACTION" == "menuconfig" ]; then
  menuconf $MODEL $VERSION
else
  echo "You must run build, update or prepare"
fi
