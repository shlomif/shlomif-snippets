#######################################################################################
# Making screencasts
#######################################################################################
# NOTE ! => If you have problems with ffmpeg hanging or something like that, just kill
# pulseaudio and start it again, perhaps with -vv switch from your user and it'll work fine afterwards.
#
# screencast_with_cam <screeencast_Title>
#
# It will delete any existing flv file with the same title. You don't need to add the .flv extension
#
#
# You need to compile ffmpeg yourself with
# make clean ; ./configure --enable-gpl --enable-pthreads --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid --enable-nonfree --enable-postproc --enable-version3 --enable-x11grab --enable-libv4l2 ; make
#
# get ffmpeg from ffmpeg.org
#
#./ffmpeg -f alsa -i pulse -f x11grab -s 1680x1050 -r 30 -i :0.0+0,0 -vf \
#"movie=/dev/video0:f=video4linux2, scale=600:-1, fps, setpts=PTS-STARTPTS [movie]; [in][movie] overlay=main_w-overlay_w-2:main_h-overlay_h-2 [out]" \
#-vcodec libx264 -crf 20 -preset veryfast -minrate 150k -maxrate 500k -s 960x540 -acodec libfaac -ar 44100 -ab 96000 -threads 0 -f flv - | tee name.flv | \
#./ffmpeg -i - -codec copy -f flv  $1
#
#
# NOTE: you might find the program called gromit useful when making screencasts.
#      (It allows the ability of making adnotations to your screen quite easily)
#
#
#
#  What Ubuntu packages are required(tried this on Ubuntu 10.10 and 12.04)
#
#
#  609  sudo aptitude install yasm
#  613  sudo aptitude install libfaac-dev libfaac0
#  616  sudo aptitude install libmp3lame-dev
#  620  sudo aptitude install libopencore-amrnb-dev
#  622  sudo aptitude install libopencore-amrwb-dev
#  624  sudo aptitude install libtheora
#  625  sudo aptitude install libtheora-dev
#  628  sudo aptitude install libv4l-dev
#  630  sudo aptitude install libvorbis-dev
#  633  sudo aptitude install libx264-dev
#  635  sudo aptitude install libxvid-dev
#  637  sudo aptitude install libxvidcore-dev
#
#

function screencast_with_cam_new() {
#Common resolutions
#640x480
#800x600
#1024x600
#1024x768
#1152x864
#1280x720
#1280x768
#1280x800
#1280x960
#1280x1024
#1360x768
#1366x768
#1400x1050
#1440x900
#1600x900
#1600x1200
#1680x1050
#1920x1080
#1920x1200
#2048x1152
#2560x1440
#2560x1600

#Increase the Scale number before ':' to make the webcam part larger

# FFMPEG_BIN=/home/user/sources/ffmpeg/ffmpeg
   FFMPEG_BIN=/usr/bin/ffmpeg
   RESOLUTION="1920x1080+0+0"
   OUT_RESOLUTION="1280x768"
   SCALE="400:-1"
   FRAMERATE="30"
   VIDEO_MINRATE="150k"
   VIDEO_MAXRATE="500k"
   AUDIO_RAW_FILE=/tmp/audio`date +%H%M%S`.wav
   AUDIO_INTERMMEDIARY=/tmp/audio_interm`date +%H%M%S`.wav
   AUDIO_SOX_PROCESSED=/tmp/audio_sox`date +%H%M%S`.wav
   INTERMMEDIARY_SCREENCAST_OUTPUT="$1.flv"
   FINAL_SCREENCAST_OUTPUT="$1-final.flv"
   ACTIVE_AUDIO_STUFF=$(pactl list | grep -A2 '^Source #' | grep 'Name: .*\.monitor$' | awk '{print $NF}' | tail -n1)
   DUMMY_FILE="/tmp/dummy.dum"

   rm -f "$INTERMMEDIARY_SCREENCAST_OUTPUT" \
         "$FINAL_SCREENCAST_OUTPUT" \
         "$AUDIO_RAW_FILE" \
         "$AUDIO_INTERMMEDIARY" \
         "$DUMMY_FILE" \
         "$AUDIO_SOX_PROCESSED";

   #parec -d "$ACTIVE_AUDIO_STUFF" | sox -t raw -r 44100 -sLb 16 -c 2 - $AUDIO_RAW_FILE &
   echo "Running FFMPEG"
   $FFMPEG_BIN -f alsa -ac 2 -i alsa -f x11grab -s $RESOLUTION -r $FRAMERATE -i :0.0+0,0  -vf \
    "movie=/dev/video0:f=video4linux2, scale=$SCALE, fps, setpts=PTS-STARTPTS [movie] ; [in][movie] overlay=main_w-overlay_w-2:main_h-overlay_h-2 [out]" \
    -vcodec libx264 -crf 20 -preset veryfast -minrate $VIDEO_MINRATE -maxrate $VIDEO_MAXRATE -s $OUT_RESOLUTION -acodec libfaac -ar 44100 -ab 96000 -threads 0 -f flv - | tee "$INTERMMEDIARY_SCREENCAST_OUTPUT" | \
    $FFMPEG_BIN -i - -codec copy -f flv "$DUMMY_FILE";
   #killall parec;
   #$FFMPEG_BIN -i $INTERMMEDIARY_SCREENCAST_OUTPUT -acodec pcm_s16le -ar 44100 -f wav $AUDIO_INTERMMEDIARY
   #sox -m $AUDIO_RAW_FILE $AUDIO_INTERMMEDIARY $AUDIO_SOX_PROCESSED
   #$FFMPEG_BIN -i $INTERMMEDIARY_SCREENCAST_OUTPUT -i $AUDIO_SOX_PROCESSED -vcodec copy -acodec libfaac $FINAL_SCREENCAST_OUTPUT
}
