#!/usr/bin/env sh

# SPDX-License-Identifier: GPL-2.0
# Copyright 2025 - Fábio Rodrigues Ribeiro and contributors

sudo sh -c "echo \"max_parallel_downloads=20\" >> /etc/dnf/dnf.conf"

sudo dnf in -y \
@development-tools \
aria2c \
fastfetch \
fedpkg \
ffmpeg-free \
fpaste \
git \
git-gui \
ImageMagick \
inxi \
koji \
koji-tool\
lua \
luanti \
nodejs \
npm \
openssl-devel\
pandoc \
python-feedparser \
python-pandas \
redhat-rpm-config \
redhat-rpm-config\
ruby-devel\
ruby\
syncthing \
unzip \
vulkan-tools \
yt-dlp \
zip
