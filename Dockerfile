FROM ubuntu:14.04
#
RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y curl git man unzip vim wget

# Install FFMPEG
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y bzip2 libgnutlsxx27 libogg0 libjpeg8 libpng12-0 \
      libvpx1 libtheora0 libxvidcore4 libmpeg2-4 \
      libvorbis0a libfaad2 libmp3lame0 libmpg123-0 libmad0 libopus0 libvo-aacenc0 \
 && rm -rf /var/lib/apt/lists/*
COPY install-ffmpeg.sh /var/cache/ffmpeg/install-ffmpeg.sh
COPY gifenc.sh /gifenc.sh
RUN bash /var/cache/ffmpeg/install-ffmpeg.sh
