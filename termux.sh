#!/usr/bin/env sh

# SPDX-License-Identifier: GPL-2.0
# Copyright 2025 - Fábio Rodrigues Ribeiro and contributors

sudo sh -c "echo \"max_parallel_downloads=20\" >> /etc/dnf/dnf.conf"

sudo dnf in -y \
lua \
git \
pandoc \
yt-dlp \
ffmpeg-free \
ImageMagick \
fastfetch \
zip \
unzip \
nodejs \
npm \
git-gui \
fedpkg \
koji \
redhat-rpm-config \
aria2c \
syncthing \
vulkan-tools \
inxi \
fpaste \
python-feedparser \
python-pandas \
luanti \
@development-tools\
ruby\
ruby-devel\
openssl-devel\
redhat-rpm-config\
koji-tool
