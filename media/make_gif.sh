#!/bin/bash

# Version: 1.3

SRC="$1"
SRC_BASE=$(basename $SRC)
FROM="$2"
LENGTH="$3"
OUT="gifs/${SRC_BASE%.*}_$(date +%Y_%m_%d_%H-%M-%S).gif"
FPS=15
SCALE=480

if [[ $# -lt 3 ]]; then
    echo 'Usage:'
    echo './make_gif.sh your_video_file 00:00:25.500 5'
    echo '                                |          |'
    echo '                from time HH:MM:SS.xxx  SS or HH:MM:SS.xxx'
    exit 1
elif [ ! -f $SRC ]; then
    echo 'File not found'
    exit 1
fi

function remove_tmp {
	rm -f tmp.mp4 >/dev/null 2>&1
	rm -f palette.png >/dev/null 2>&1
}

function make_gif {
	ffmpeg -i $SRC -ss $FROM -t $LENGTH -vcodec copy -an tmp.mp4
	ffmpeg -v warning -i tmp.mp4 -vf "fps=$FPS,scale=$SCALE:-1:flags=lanczos,palettegen" -y palette.png
	ffmpeg -v warning -i tmp.mp4 -i palette.png -filter_complex "fps=$FPS,scale=$SCALE:-1:flags=lanczos[x]; [x][1:v] paletteuse" -y $OUT
}

remove_tmp
make_gif
remove_tmp