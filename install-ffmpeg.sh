#!/bin/bash
set -e

apt-get update
apt-get -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev

mkdir ~/ffmpeg_sources

# yasm
echo "build yasm"
apt-get install yasm
cd ~/ffmpeg_sources
wget "https://mirror.fungjai.com/ffmpeg/yasm-1.3.0.tar.gz"
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
make distclean

# # libx264
# apt-get install libx264-dev
# cd ~/ffmpeg_sources
# wget "https://mirror.fungjai.com/ffmpeg/last_x264.tar.bz2"
# tar xjvf last_x264.tar.bz2
# cd x264-snapshot*
# PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
# PATH="$HOME/bin:$PATH" make
# make install
# make distclean
#
# # libx265
# sudo apt-get install cmake mercurial
# cd ~/ffmpeg_sources
# hg clone https://bitbucket.org/multicoreware/x265
# cd ~/ffmpeg_sources/x265/build/linux
# PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
# make
# make install
# make distclean

# libfdk-aac
echo "build libfdk-aac"
cd ~/ffmpeg_sources
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
tar xzvf fdk-aac.tar.gz
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean

#libmp3lame
echo "build libmp3lame"
apt-get install libmp3lame-dev
sudo apt-get install nasm
cd ~/ffmpeg_sources
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared
make
make install
make distclean

# # libopus
# apt-get install libopus-dev
# cd ~/ffmpeg_sources
# wget https://mirror.fungjai.com/ffmpeg/opus-1.1.tar.gz
# tar xzvf opus-1.1.tar.gz
# cd opus-1.1
# ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
# make
# make install
# make clean
#
# #libvpx
# cd ~/ffmpeg_sources
# wget https://mirror.fungjai.com/ffmpeg/libvpx-1.5.0.tar.bz2
# tar xjvf libvpx-1.5.0.tar.bz2
# cd libvpx-1.5.0
# PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests
# PATH="$HOME/bin:$PATH" make
# make install
# make clean

#ffmpeg
echo "build ffmpeg"
cd ~/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-nonfree
PATH="$HOME/bin:$PATH" make
make install
make distclean
hash -r

ln -s /root/bin/ffmpeg /bin/ffmpeg

echo "cleaning..."
apt-get purge -y --auto-remove autoconf automake build-essential

rm -rf ~/ffmpeg_sources
rm -rf /var/lib/apt/lists/*
