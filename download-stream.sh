#!/bin/bash

# movie/tv show name
NAME=$1
# movie/tv show link
MOVIE_LINK=$2
# set link
LINK=($MOVIE_LINK)

function is_ffmpeg_required {
  if brew ls --versions ffmpeg > /dev/null; 
    then
    install_ffmpeg=false
  else
    install_ffmpeg=true
  fi
}

is_ffmpeg_required

if $install_ffmpeg
  then
  echo "Installing ffmpeg...🍿 🎥 🎬"
  brew install ffmpeg
  wait
fi

if [[ $NAME == "" ]]
 then
 echo "A movie/tv show name must be provided"
 exit 1
fi

for URL in ${LINK[@]}
do
  mkdir $NAME
  cd $NAME
  (
    DIR="${URL##*/}"
    for i in $(seq -f "%04g" 0 10)
    do
      wget $URL'-'$i.ts --header "Referer: bxjlp.mcloud.to"
      cat $DIR'-'$i.ts >> $NAME.ts
    done
    ffmpeg -i $NAME.ts -acodec copy -vcodec copy $NAME.mp4
    rm *.ts
  )
done
