README
======

This is my very own MAME fork (historically, because I didn't want to wait until they fixed 
galaga in 0.154, and now just because I can:-) ). Also, it contains some small additions to 
make it suitable for my Linux-based MAME cabinet by including MKChamp's Hiscore patch.

ONE-TIME SETUP
--------------
To build mame, you need to install the following packages:

```bash
sudo apt-get install --no-install-recommends \
    make \
    gcc \
    libsdl2-dev \
    libsdl2-ttf-dev \
    libx11-dev \
    libqt4-dev \
    libfontconfig1-dev \
    libxinerama-dev
```

BUILD
-----
```bash
cd /path/to/project
make
```
