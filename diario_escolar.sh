#!/bin/bash

#funcao usada para matar o programa
function fatal() {
	echo "[-] Error: $@" 1>&2;
	exit 1;
}

#testa se tem 2 argumentos passados
if [ $# -ne 2 ]; then
	echo "Usage: ./diario_escolar [acao] [arquivo]";
	echo "Lembre-se:";
	echo "Comandos disponiveis: ler, remover, escrever";
	echo "Formato de escrita: [materia],[pontuacao: pontos,total]";
	exit 1;
fi

#testa arquivo passado pelo usuario
function existe_arq() {
	[ -f $1 ] || fatal "Arquivo nao existe";
	[ -r $1 ] || fatal "Arquivo nao legivel";
}


#faz a leitura e analise dos dados
function leitura(){
	echo "Suas notas sao: ";
	echo "";
	gawk -F"," 'BEGIN {
				print "Materia		Notas	Total";
				print "---------------------------------";
			  }
			  {
				for (i=2;i<=NF; i = i + 2) {
					printf "%-15s %5.2f\t%5.2f\n", $1, $i, $(i+1);
					parcial[$1] = parcial[$1] + $i;
					distribuidos[$1] = distribuidos[$1] + $(i+1);
				}
				print "---------------------------------";
			  }
		    END   {
				print "\nEsses sao os pontos que voce tem no momento\n";
				print "Materia		Parcial	 Distribuidos	Falta	 Falta";
				print "					para 	 para";
				print "					Passar   Distribuir";
				print "--------------------------------------------------------------";

				for (mat in distribuidos) {
					sobra = 100 - distribuidos[mat];
					precisa = 60 - parcial[mat];

					printf "%-15s\t %5.2f\t %5.2f\t\t%5.2f\t  %5.2f\n\n", mat, parcial[mat], distribuidos[mat], precisa, sobra;
				}

			  } ' $1;
}

#atribuicao dos parametros
acao=$1;
arq=$2;

#testa a acao passada pelo usuario
case "$acao" in
	ler)
			existe_arq "$arq";
			leitura "$arq";
		;;

	remover)
			existe_arq "$arq";
			rm "$arq";
		;;

	escrever)
			nano "$arq";
		;;

	*)
			echo "Acao invalida, Acao validas: ler, escrever, remover";
		;;
esac
