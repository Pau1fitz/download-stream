#!/bin/bash

# insert url here
LINK=(
  'https://bxjlp.mcloud.to/26/2b8bd5748b8df2a0/75075bf5e8f8a9ac95dd6f4b55a2eb695c86e4fee5c5f7910697bb6723a89bb9718e30e74e69122680a911ed900994bcd3c9bca379fa7bd2ce1fe7e602bb0cb53a8feebd8e112be60cd1a430f6aa4cb8ed5ac43baf27a6f7949107b57d7040d681a292660e3afdf4979a7d458d227411/hls/480/480' # replace this with your url 
)

# movie/tv show name
NAME=$1

function is_ffmpgeg_required {
  if brew ls --versions ffmpeg > /dev/null; then
    install_bash=false
  else
    install_bash=true
  fi
}

is_ffmpgeg_required

if $install_bash
  then
  echo "Installing ffmpeg..."
  brew install ffmpeg
  wait
fi

if [[ $NAME == "" ]]
 then
 echo "A movie/tv show name must be provided"
 exit 0
fi

for URL in ${LINK[@]}
do
  # create folder for streaming media
  mkdir $NAME
  cd $NAME
  (
    DIR="${URL##*/}"
    # download all videos
    for i in $(seq -f "%04g" 0 1000)
    do
      echo $DIR'-'$i.ts
      wget $URL'-'$i.ts --header "Referer: bxjlp.mcloud.to"
      echo $DIR'-'$i.ts
      cat $DIR'-'$i.ts >> $NAME.ts
    done

    ffmpeg -i $NAME.ts -acodec copy -vcodec copy $NAME.mp4  
  )
done
