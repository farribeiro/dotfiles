#!/bin/sh

mkdir 800x600

export a = ""

log(){
	export backup = date %d%m%Y | sed -e "s/^\(\d\{2\}\)\(\1\)\(\d\{4\}\)/\1-\2-\3/g"
}

backup(){
	find $dir -mtime 180 -type f | xargs cp /
}

padrao(){
	find $dir -mtime +$dias -type f |
}

resize{
	shopt -s nocasematch
	for i in *.jpg | *.jpeg; do
		convert -resize 800x600 $i "800x600/$i"
	done
}

grava(){
	echo "Coloque o CD que quer copiar
"	eject
	read a
	echo "Fazendo a imagem ..."
	dd if=/dev/cdrom of=/tmp/cdrom.iso
	echo "Imagem pronta, Ejetando ... "
	eject
	echo "Coloque um CD limpo ... "
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

	"-h" | "-?" | *)
		echo "sintaxe: [-b|-p"
	;;
esac