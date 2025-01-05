#!/bin/sh

# Conversor e backupeador de fotos
# =================================
#

# (c) Fábio Rodrigues Ribeiro - http://farribeiro.blogspot.com

# Copying and distribution of this file, with or without modification, are permitted
# in any medium without royalty provided the copyright notice and this notice are
# preserved.  This file is offered as-is, without any warranty.

mkdir 800x600

log(){
	backup = date %d%m%Y | sed -e "s/^\(\d\{2\}\)\(\1\)\(\d\{4\}\)/\1-\2-\3/g"
}

backup(){
	find $dir -mtime 180 -type f | xargs cp /
}

padrao(){
	find $dir -mtime +$dias -type f #|
}

resize(){
	shopt -s nocasematch
	for i in (*.jpg||*.jpeg||*.png); do
		convert -resize 800x600 $i "800x600/$i"
	done
}

resize_web(){
	nkdir www
	shopt -s nocasematch
	for i in (*.jpg||*.jpeg||*.png); do
		convert -depth 72 $i "www/$i";
	done
}

grava(){
	echo "Coloque o CD que quer copiar"
	eject
	read a
	echo "Fazendo a imagem ..."
	dd if=/dev/cdrom of=/tmp/cdrom.iso
	echo "Imagem pronta, Ejetando ..."
	eject
	echo "Coloque um CD limpo ..."
	read a
	cdrecord -v dev=/dev/cdrom -speed=4 -data /tmp/cdrom.iso
	echo "Removendo a imagem, Ejetando ..."
	rm /tmp/cdrom.iso
	sleep 5s
	eject -T /dev/cdrom
}

case $1 in
	"-b" )
		backup
		log
	;;

	"-r" )
		resize
	;;

	"-a" | "--avatar"

	"-h" | "-?" | *)
		echo "sintaxe: [-b|-p"
		exit 0
	;;
esac
