
#!/bin/bash

# Este script varre o servidor de arquivos em busca de arquivos executáveis e
# autorun na raiz do compartilhamento

$files = "*.cmd *.exe *.pif *.bat autorun.inf recycler recycler32"

apagar(){
  shopt -s nocasematch # desativa o case sensitive do shell
  rm -rf $files
  shopt -u nocasematch
}

log(){
	#####################
	#   10/01/2013      #
	#   Diego Godoi     #
	#####################

	# Diretorios logdir e logdel devem ser modificados conforme a sua
	# necessidade

	logdir="/var/log"
	logdel="/var/log/log-del"
	data="date +%d%m%Y"

	echo "Script para Exclusão de arquivos em massa Por data "

	#Pega o Diretorio e joga na varialvel dir
	echo -n "Digite o Diretorio a Ser Excluido: "
	read dir

	#Pega a Data e jogo na variavel Dia
	echo -n "Digite os Dias a Ser Excluido(Ex:30 -> Vais Excluir todos os arquivos com mais de 30 dias):$"
	read dias

	echo "\n---------Iniciado as -> "`date +%H:%M:%S` >> $logdel

	#echo "---------O Script irá excluir os arquivos com mais de 90 dias" >> $logdel
	#Monta o Find com $dir e $dias que foi Digitado
	find $dir -mtime +$dias -type f -exec rm {} \; >> $logdel

	echo "-------------- Excluido os arquivos com mais de 90 dias --------------" >> $logdel
	echo "-------------- Excluido os arquivos com mais de 90 dias --------------"
	echo "-------------- FIM -> "`date +%H:%M:%S` >> $logdel
	echo "-------------- FIM -> "`date +%H:%M:%S`
}

case $1 in
	"-d" )
		cd $2; apagar
	;;
	"-?" )
		echo "Sintaxe: limpaexe.sh [-d][-s] <diretório>\n
		Caso o comando executado sem opção será considerado o diretório atual\n\n
		-d\t\tApaga arquivos suspeitos no diretório indicado"
	;;

	"-l")
		log
	;;

	*)
		apagar
	;;
esac
done
