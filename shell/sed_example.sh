#!/bin/bash

readonly BLUE="\\033[1;34m"
readonly END="\\033[1;00m"

info() {
	echo -e "$BLUE [INFO] $* $END"
}


echo ""

# Ne pas afficher les lignes blanches
info "Ne pas afficher les lignes blanches"
sed '/^[  ]*$/d' tel2.txt
echo ""

info "Affiche les lignes de 1 à 4"
sed -n '1,4p' tel2.txt
echo ""

info "Ecriture dans le fichier dpt_56 tous les habitants du departement 56"
sed -n -e '/^[^|]*|[^|]*|56/w dpt_56' tel2.txt
echo ""

info "Ne pas afficher les lignes blanches ( en utilisant la negation)"
sed -n '/^[  ]*$/!p' tel2.txt
echo ""

info "Substitution d'une chaine de caractere : Exemple 1"
arg=user1,user2,user3
echo $arg | sed 's/,/ /g'
echo ""

info "Substitution d'une chaine de caractere : Exemple 2"
line=$(sed -n '2p' tel2.txt)
echo $line | sed 's/.*/(&)/'
echo ""

info "Substitution d'une chaine de caractere : Exemple 3"

sed 's/^\([^|]*|[^|]*|56...|[^|]*|\)\(.*\)$/\102.\2/' tel2.txt
#sed -r ’s/^([^|]*|[^|]*|56...|[^|]*|)(.*)$/\102.\2/’ tel2.txt
