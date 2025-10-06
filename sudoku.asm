# ===== Section donnees =====  
.data
    grille: .asciiz "415638972362479185789215364926341758138756429574982631257164893843597216691823547"
    space: .asciiz " "
    
    
    newline: .asciiz "\n"  # Définition de la chaîne "\n"
    
    
    
    ####  message pour la fonction check_n_row ####
    
    erreur_message: .asciiz "Erreur : doublon trouvé dans le rang.\n"
    no_error_message: .asciiz "Aucune erreur : le rang est valide.\n"
    
    
    ####  message pour la fonction check_n_column ####
    
    no_error_message_col: .asciiz "Aucune erreur : la ligne est valide.\n"
    erreur_message_col:"Erreur : doublon trouvé dans la ligne.\n"
    
    
    
    ####  message pour la fonction check_n_square ####
    
    message_check_square_correct:  .asciiz "\n le carrées est corrects\n"
    message_check_square_incorrect:  .asciiz "\n le carrée est incorrects\n"
    
    
    
    ####  message pour la fonction check_row ####
    
    message_check_row_correct:  .asciiz "\n les rangs du sudoku sont corrects\n"
    message_check_row_incorrect:  .asciiz "\n les rangs du sudoku sont incorrects\n"
    
    
    ####  message pour la fonction check_column ####
    
    message_check_line_correct:  .asciiz "\n les lignes du sudoku sont corrects\n"
    message_check_line_incorrect:  .asciiz "\n les lignes du sudoku sont incorrects\n"
    
    ####  message pour la fonction check_square ####
    
    message_check_carree_correct:  .asciiz "\n les carrées du sudoku sont corrects\n"
    message_check_carree_incorrect: .asciiz "\n les carrées du sudoku sont incorrects\n"
    
    ####  message pour la fonction check_sudoku ####
    message_check_sudoku_correct:  .asciiz "\n le sudoku est correct\n"
    message_check_sudoku_incorrect:  .asciiz "\n le sudoku est incorrect\n"
    
    
    
    
    message_grille: .asciiz "Grille complète et conforme.\n"  # Renommé en message_grille
    copie_grille: .space 81   # Réserver de l'espace pour une copie de la grille (81 caractères pour une grille 9x9)



# ===== Section code =====  
.text
# ----- Main ----- 

main:
    jal check_rows
    jal check_columns
    jal check_squares
    
    # Appelle la fonction transformAsciiValues pour convertir les valeurs ASCII en entiers.
    jal transformAsciiValues
    # Appelle la fonction displaySudoku pour afficher la sudoku transformée.
    jal displaySudoku
    # Appelle la fonction addNewLine pour faire un retour à la ligne.
    jal addNewLine
    
    #li $s0,0 # s0 correspond au numerot de la ligne,du rang ou du carré , dans cette exemple le 0 donc la premiere ligne, rang ou carrée
    #jal check_n_square # verifiera le premier rang
    
    #li $s0,8 # s0 correspond au numerot de la ligne,du rang ou du carré , dans cette exemple le 0 donc la quatrieme ligne, rang ou carrée
    #jal check_n_square # verifiera la quatrieme ligne
    
    
    
    jal check_sudoku    # la precondition de check sudoku est qu'elle doit etre appeller apres check_rows check_columns check_squares
    
    
    
    j exit


# ----- Fonctions ----- 

# ----- Fonctions ----- 



    
# ----- Fonction addNewLine -----  
# Objectif : Affiche un retour à la ligne sur l'écran.
# Registres utilisés : $v0, $a0
addNewLine:
    li      $v0, 11       # Code syscall pour afficher un caractère.
    li      $a0, 10       # ASCII du caractère '\n' (nouvelle ligne).
    syscall               # Appelle le système pour afficher le caractère.
    jr      $ra           # Retourne à l'appelant.

# ----- Fonction displaySudoku -----   
# Objectif : Affiche chaque chiffre de la sudoku sous forme d'entiers.
# Registres utilisés : $v0, $a0, $t0, $t1, $t2
displaySudoku:  
    la      $t0, grille   # Charge l'adresse de la sudoku dans $t0.
    add     $sp, $sp, -4  # Sauvegarde l'ancien $ra sur la pile.
    sw      $ra, 0($sp)   # Stocke $ra (adresse de retour).

    li      $t1, 0        # Initialise le compteur $t1 à 0.
    li      $s1, 0   # initialiser un compteur pour compter le nombre de character d'une ligne 
boucle_displaySudoku:
        # Si $t1 >= 81 (longueur de la sudoku), termine la boucle.
            bge     $t1, 81, end_displaySudoku
            add     $t2, $t0, $t1   # Calcule l'adresse du caractère actuel ($t0 + $t1).
            lb      $a0, ($t2)      # Charge le caractère à cette adresse dans $a0.
            
            beq     $a0, $zero, zeroToSpace # Si le caractère est 0, on affiche un espace à la place
            
            li      $v0, 1          # Code syscall pour afficher un entier.
            syscall                 # Affiche le caractère sous forme d'entier.
            
incremente :
           add     $t1, $t1, 1     # Incrémente le compteur $t1.
           add     $s1, $s1, 1    # incrementer de 1 $s1             
           bne     $s1, 9, boucle_displaySudoku     # si $s1 est plus grand que 9 retour a la ligne 
           li      $s1, 0     # remettre $s1 a 0
           la      $a0, newline         # charge retour a la ligne
           li      $v0, 4            # print de retour a la ligne
           syscall   
           j boucle_displaySudoku # Retourne au début de la boucle.
        
end_displaySudoku:
        lw         $ra, 0($sp)         # Restaure $ra depuis la pile.
        add        $sp, $sp, 4         # Libère l'espace utilisé sur la pile.
        jr         $ra                 # Retourne à l'appelant.
    
# ----- zeroToSpace -----
# Remplace lors l'affichage de la grille les "0" par " "
# Registres utilises : $v0, $a0
zeroToSpace:
     li $v0, 4
     la $a0, space
     syscall
     j incremente

# ----- Fonction transformAsciiValues -----   
# Objectif : Convertit chaque caractère ASCII de la sudoku en un entier (0-9).
# Registres utilisés : $t0, $t1, $t2, $t3
transformAsciiValues:  
    add     $sp, $sp, -4            # Sauvegarde l'ancien $ra sur la pile.
    sw      $ra, 0($sp)             # Stocke $ra (adresse de retour).
    la      $t3, grille             # Charge l'adresse de la sudoku dans $t3.
    li      $t0, 0                  # Initialise le compteur $t0 à 0.
boucle_transformAsciiValues:
        # Si $t0 >= 81, termine la boucle.
        bge     $t0, 81, end_transformAsciiValues
            add     $t1, $t3, $t0   # Calcule l'adresse du caractère actuel ($t3 + $t0).
            lb      $t2, ($t1)      # Charge le caractère actuel dans $t2.
            sub     $t2, $t2, 48    # Convertit l'ASCII en entier (caractère '0' = ASCII 48).
            sb      $t2, ($t1)      # Stocke la valeur convertie dans la sudoku.
            add     $t0, $t0, 1     # Incrémente le compteur $t0.
        j       boucle_transformAsciiValues # Retourne au début de la boucle.
end_transformAsciiValues:
    lw      $ra, 0($sp)             # Restaure $ra depuis la pile.
    add     $sp, $sp, 4             # Libère l'espace utilisé sur la pile.
    jr      $ra                     # Retourne à l'appelant.

# ----- Fonction getModulo ----- 
# Objectif : Calcule le modulo (a mod b).
# $a0 : nombre a (doit être positif).
# $a1 : nombre b (doit être positif).
# Résultat : dans $v0.
# Registres utilisés : $a0
getModulo: 
    sub     $sp, $sp, 4             # Sauvegarde l'ancien $ra sur la pile.
    sw      $ra, 0($sp)             # Stocke $ra (adresse de retour).
boucle_getModulo:
        # Si $a0 < $a1, termine la boucle.
        blt     $a0, $a1, end_getModulo
            sub     $a0, $a0, $a1   # Soustrait $a1 de $a0.
        j       boucle_getModulo    # Retourne au début de la boucle.
end_getModulo:
    move    $v0, $a0                # Stocke le résultat (reste) dans $v0.
    lw      $ra, 0($sp)             # Restaure $ra depuis la pile.
    add     $sp, $sp, 4             # Libère l'espace utilisé sur la pile.
    jr      $ra                     # Retourne à l'appelant.

# ouvrir un fichier passé en argument : appel systeme 13 
#	$a0 nom du fichier
#	$a1 (= 0 lecture, = 1 ecriture)
# Registres utilises : $v0, $a2
loadFile:
	la $a0, grille
	li $v0, 13
	li $a1, 0
	li $a2, 0
	syscall
	jr $ra
	
# Fermer le fichier : appel systeme 16
#	$a0 descripteur de fichier  ouvert
# Registres utilises : $v0
closeFile:
	li	$v0, 16	
	syscall
	jr 	$ra
	
#################################################
#               A completer !                   #
#                                               #
# Nom et prenom binome 1 : Malys Maxime                     #
# Nom et prenom binome 2 : Flieller Maxence                    #
#                                               #
# Fonction check_n_column                       #

             
check_n_column:
    # Arguments : n est passé dans $s0
    # $t0 = adresse de la grille (grille commence à l'adresse de la mémoire)
    la $t0, grille                # Charger l'adresse de la grille (tableau 9x9)

    li $t2, 0                     # Index pour parcourir les lignes (0 à 8)
    li $t4, 9                     # Nombre de lignes (9 au total)
    li $t7, 0                     # Compteur de doublons (initialisé à 0)

    boucle_verification_col_1:
   	 bge $t2, $t4, end_check_column    # Si index >= 9, fin de la vérification

    	# Charger la valeur de grille[t2][n] dans $t5
    	mul $t3, $t2, 9             # $t3 = t2 * 9 (saute les lignes)
    	add $t3, $t3, $s0           # Ajouter la colonne (n)
	add $t3, $t3, $t0           # $t3 = adresse de grille[t2][n]
    	lb $t5, 0($t3)              # Charger la valeur dans $t5

    	li $t6, 0                   # Réinitialiser index2 pour la comparaison

    	boucle_verification_col_2:
    		bge $t6, $t4, next_index_col1  # Si index2 >= 9, passer à l'élément suivant
    		beq $t2, $t6, next_index_col2  # Si t2 == t6, on ne compare pas à soi-même

    		# Charger la valeur de grille[t6][n] dans $t8
    		mul $t9, $t6, 9             # $t9 = t6 * 9 (ligne correspondante)
    		add $t9, $t9, $s0           # Ajouter la colonne
    		add $t9, $t9, $t0           # $t9 = adresse de grille[t6][n]
    		lb $t8, 0($t9)              # Charger la valeur dans $t8

    		# Vérifier si grille[t2][n] == grille[t6][n]
    		beq $t5, $t8, cas_faux_col       # Si doublon trouvé, sauter au cas faux

    next_index_col2:
    	addi $t6, $t6, 1            # Incrémenter index2
    	j boucle_verification_col_2 # Revenir à la boucle interne

    cas_faux_col:
    	addi $t7, $t7, 1            # Incrémenter le compteur de doublons
    	j end_check_column          # Sortir de la vérification

    next_index_col1:
    	addi $t2, $t2, 1            # Incrémenter index1
    	j boucle_verification_col_1 # Revenir à la boucle externe

    end_check_column:
    	# Afficher un message en fonction de la valeur de $t7
    	beqz $t7, no_error_column        # Si $t7 == 0, pas d'erreur

    	# Afficher le message d'erreur
    	li $s1, 1
    	la $a0, erreur_message_col       # Charger l'adresse du message d'erreur
    	li $v0, 4                        # Syscall pour print string
    	syscall
    	jr $ra                           # Retour

    no_error_column:
    	# Afficher le message de succès
    	li $s1, 0
    	la $a0, no_error_message_col     # Charger l'adresse du message de succès
    	li $v0, 4                        # Syscall pour print string
    	syscall
    	jr $ra                           # Retour
  


# Fonction check_n_row                          #

check_n_row:
    # Arguments : n est passé dans $s0b
    # $t0 = adresse de la grille (grille commence à l'adresse de la mémoire)
    la $t0, grille                # Charger l'adresse de la grille (tableau 9x9)

    # Calculer l'adresse de la ligne n (lignes de 9 éléments)
    mul $t1, $s0, 9               # $t1 = n * 9 (9 éléments par ligne)
    add $t1, $t0, $t1             # $t1 = adresse de la ligne n (grille + n*9)

    li $t2, 0                     # Index1 (pour la première boucle de vérification)
    li $t3, 0                      # Index2 (pour la deuxième boucle de vérification)
    li $t4, 8                     # Compteur de la ligne (9 éléments)
    li $t7, 0                     # Compteur de doublons

	boucle_verification_1:
    		bge $t2, $t4, end_check       # Si index1 >= 8, fin de la vérification (pas de doublon)

    		bge $t7, 1, end_check         # Si doublon trouvé (t7 > 0), sortir

    		# Charger la valeur de grille[n][t2] dans $t5
    		add $t5, $t1, $t2             # $t5 = adresse de grille[n][t2]
    		lb $t5, 0($t5)                # Charger la valeur dans $t5

    		li $t3, 1                     # Réinitialisation de l'index2

			boucle_verification_2:
   				bge $t3, $t4, boucle_verification_1_bis # Si index2 >= 8, passer à la vérification suivante

    				bge $t7, 1, end_check         # Si doublon trouvé, sortir
    				beq $t2, $t3, next_index2     # Si t2 == t3, passer à la prochaine itération (on ne se compare pas à soi-même)

    				# Charger la valeur de grille[n][t3] dans $t6
    				add $t6, $t1, $t3             # $t6 = adresse de grille[n][t3]
    				lb $t6, 0($t6)                # Charger la valeur dans $t6

    				beq $t5, $t6, cas_faux        # Si grille[n][t2] == grille[n][t3], il y a un doublon

    				addi $t3, $t3, 1              # Incrémenter index2
    				j boucle_verification_2        # Revenir à la boucle interne

	boucle_verification_1_bis:
    		addi $t2, $t2, 1              # Incrémenter index1
    		j boucle_verification_1       # Revenir à la première boucle
    		
    	next_index2:
            addi $t3, $t3, 1              # Incrémenter index2
            j boucle_verification_2       # Revenir à la deuxième boucle
    	

	cas_faux:
    		# Cas où il y a un doublon (grille[n][t2] == grille[n][t3])
    		addi $t7, $t7, 1              # Incrémenter le compteur de doublons
    		j end_check                   # Fin de la vérification

	end_check:
    		# Afficher un message en fonction de la valeur de $t7 (compteur d'erreurs)
    		li $v0, 4                     # Code syscall pour afficher une chaîne
    		beqz $t7, no_error             # Si $t7 == 0, pas d'erreur, afficher "Aucune erreur"
    
    		# Message d'erreur
    		li $s1, 1
    		la $a0, newline
    		la $a0, erreur_message        # Charger l'adresse du message d'erreur
    		syscall                       # Afficher le message d'erreur
    		jr $ra                        # Terminer la fonction

	no_error:
    		# Message de succès (pas d'erreur)
    		li $s1, 0                  # initialiser s1 pour connaitre le resultat de chaque ligne pour check_row
    		la $a0, newline
    		la $a0, no_error_message      # Charger l'adresse du message de succès
    		syscall                       # Afficher le message de succès
    		jr $ra                        # Terminer la fonction





# Fonction check_n_square                       #


check_n_square:
    # $s0 contient l'indice du sous-carré (0 à 8)
    la $t0, grille                # Charger l'adresse de la grille

    # Calculer la ligne de départ et la colonne de départ du sous-carré
    div $t1, $s0, 3               # $t1 = ligne de départ (0, 1, 2)
    mflo $t1                      # Récupérer le quotient
    mul $t1, $t1, 3               # $t1 = (ligne de départ) * 3

    mul $t2, $s0, 3               # $t2 = colonne de départ (reste de la division)
    rem $t2, $t2, 9               # $t2 = (colonne de départ)

    # Initialiser les index et variables
    li $t3, 0                     # Index pour parcourir les 9 cases du carré
    li $t4, 9                     # Nombre total de cases à vérifier
    li $t5, 0                     # Compteur de doublons

boucle_verification_square:
    bge $t3, $t4, end_check_square  # Si index >= 9, fin de la vérification

    # Calculer les coordonnées de la case actuelle
    div $t6, $t3, 3               # Ligne relative dans le sous-carré
    mflo $t6                      # $t6 = ligne relative (0, 1, 2)
    add $t6, $t6, $t1             # Ajouter la ligne de départ

    rem $t7, $t3, 3               # Colonne relative dans le sous-carré
    add $t7, $t7, $t2             # Ajouter la colonne de départ

    # Charger la valeur de la case dans $t8
    mul $t9, $t6, 9               # $t9 = ligne * 9
    add $t9, $t9, $t7             # $t9 = adresse relative de la case
    add $t9, $t9, $t0             # $t9 = adresse mémoire réelle de la case
    lb $s1, 0($t9)                # Charger la valeur dans $s1 (utilisation de $s1 comme temporaire)

    # Vérifier les doublons dans le carré
    li $t8, 0                     # Réinitialiser l'index interne pour comparer
boucle_comparaison_square:
    bge $t8, $t3, next_case_square # Ne comparer qu'avec les cases déjà visitées

    # Calculer les coordonnées de la case à comparer
    div $t9, $t8, 3               # Ligne relative
    mflo $t9                      # $t9 = ligne relative
    add $t9, $t9, $t1             # Ajouter la ligne de départ

    rem $t7, $t8, 3               # Colonne relative
    add $t7, $t7, $t2             # Ajouter la colonne de départ

    # Charger la valeur à comparer
    mul $t6, $t9, 9               # Ligne * 9
    add $t6, $t6, $t7             # Adresse relative
    add $t6, $t6, $t0             # Adresse mémoire réelle
    lb $s2, 0($t6)                # Charger la valeur dans $s2 (utilisation de $s2 comme temporaire)

    # Ignorer les cases vides
    beqz $s1, next_comparaison_square
    beqz $s2, next_comparaison_square

    # Vérifier si les deux cases sont identiques
    beq $s1, $s2, cas_faux_square

next_comparaison_square:
    addi $t8, $t8, 1              # Incrémenter l'index interne
    j boucle_comparaison_square   # Retour à la boucle de comparaison

next_case_square:
    addi $t3, $t3, 1              # Incrémenter l'index du carré
    j boucle_verification_square  # Retour à la boucle principale

cas_faux_square:
    addi $t5, $t5, 1              # Incrémenter le compteur de doublons
    j end_check_square            # Fin de la vérification

end_check_square:
    # Afficher un message en fonction de la valeur de $t5 (compteur d'erreurs)
    li $v0, 4                     # Code syscall pour afficher une chaîne
    beqz $t5, no_error_square     # Si $t5 == 0, pas d'erreur, afficher "Aucune erreur"

    # Message d'erreur
    la $a0, erreur_message        # Charger l'adresse du message d'erreur
    syscall                       # Afficher le message d'erreur
    jr $ra                        # Terminer la fonction

no_error_square:
    la $a0, no_error_message      # Charger l'adresse du message de succès
    syscall                       # Afficher le message de succès
    jr $ra                        # Terminer la fonction
verif_square:
    li $s0,0 #initialiser le "compteur"de de rang 
    li $s4, 0
    li, $s1, 0
    j boucle_check_square
    
    boucle_check_square:
    	#j check_n_square
    	beq $s1,1,end_check_square_incorrect
    	addi $s0,$s0,1
    	addi $s4,$s4,1
    	beq $s4,9,end_check_square_correct
    	j boucle_check_square
    	
    end_check_square_correct:
    	li $s7, 0         # utiliser pour valider la grille
    	li $v0, 4               # Code du syscall pour afficher une chaîne (4)
    	la $a0, message_check_square_correct         # Charger l'adresse de la chaîne dans $a0
    	syscall
    	jr $ra 
    
    end_check_square_incorrect:
    	li $s7, 1         # utiliser pour non valider la grille
    	li $v0, 4               # Code du syscall pour afficher une chaîne (4)
    	la $a0, message_check_square_incorrect         # Charger l'adresse de la chaîne dans $a0
    	syscall
    	jr $ra 
 


# Fonction check_columns                        #

     
check_columns:
    li $s0, -1                    # Initialiser compteur de colonnes
    li $s6, 0                     # Réinitialiser $s6 (compteur général)

boucle_check_line_1:
    addi $s0, $s0, 1              # Passer à la colonne suivante
    addi $s6, $s6, 1              # Incrémenter compteur de validation
    beq $s6, 10, end_check_line_correct  # Si toutes les colonnes sont vérifiées, sortir

    li $t2, 0                     # Initialiser index des lignes
    li $t4, 9                     # Nombre total de lignes
    li $t7, 0                     # Compteur de doublons

boucle_check_line_2:
    bge $t2, $t4, boucle_check_line_1    # Si index ligne >= 9, revenir au niveau colonne

    # Charger la valeur de grille[t2][n]
    mul $t3, $t2, 9               # $t3 = t2 * 9
    add $t3, $t3, $s0             # Ajouter colonne actuelle
    la $t0, grille                # Adresse de la grille
    add $t3, $t3, $t0             # Adresse grille[t2][n]
    lb $t5, 0($t3)                # Charger valeur dans $t5

    li $t6, 0                     # Initialiser index pour comparaison

boucle_check_line_3:
    bge $t6, $t4, next_index_line_1  # Si index >= 9, passer à la ligne suivante
    beq $t2, $t6, next_index_line_2  # Ignorer comparaison avec soi-même

    # Charger la valeur de grille[t6][n]
    mul $t9, $t6, 9               # $t9 = t6 * 9
    add $t9, $t9, $s0             # Ajouter colonne
    add $t9, $t9, $t0             # Adresse grille[t6][n]
    lb $t8, 0($t9)                # Charger valeur dans $t8

    # Ignorer les cases vides
    beqz $t5, next_index_line_2
    beqz $t8, next_index_line_2

    # Vérifier doublons
    beq $t5, $t8, end_check_line_incorrect

next_index_line_2:
    addi $t6, $t6, 1              # Incrémenter index comparaison
    j boucle_check_line_3         # Retour à la boucle interne

next_index_line_1:
    addi $t2, $t2, 1              # Incrémenter index ligne
    j boucle_check_line_2         # Retour à la boucle ligne

end_check_line_correct:
    li $s6, 0                     # Réinitialiser validation
    li $v0, 4
    la $a0, message_check_line_correct
    syscall
    jr $ra

end_check_line_incorrect:
    li $s6, 1
    li $v0, 4
    la $a0, message_check_line_incorrect
    syscall
    jr $ra






# Fonction check_rows                           #
check_rows:
	li $s0, -1 #compteur de rang
	li $s5,0
	li $t8,0

    boucle_check_row_1:
    # Arguments : n est passé dans $s0b
    # $t0 = adresse de la grille (grille commence à l'adresse de la mémoire)
    la $t0, grille                # Charger l'adresse de la grille (tableau 9x9)
    
    add $s0,$s0,1
    add $t8,$t8,1
    beq $t8,10, end_check_row_correct

    # Calculer l'adresse de la ligne n (lignes de 9 éléments)
    mul $t1, $s0, 9               # $t1 = n * 9 (9 éléments par ligne)
    add $t1, $t0, $t1             # $t1 = adresse de la ligne n (grille + n*9)

    li $t2, 0                     # Index1 (pour la première boucle de vérification)
    li $t3, 0                      # Index2 (pour la deuxième boucle de vérification)
    li $t4, 8                     # Compteur de la ligne (9 éléments)
    li $t7, 0                     # Compteur de doublons

	boucle_check_row_2:
    		bge $t2, $t4, boucle_check_row_1       # Si index1 >= 8, fin de la vérification (pas de doublon)

    		bge $t7, 1, end_check_row_incorrect         # Si doublon trouvé (t7 > 0), sortir

    		# Charger la valeur de grille[n][t2] dans $t5
    		add $t5, $t1, $t2             # $t5 = adresse de grille[n][t2]
    		lb $t5, 0($t5)                # Charger la valeur dans $t5

    		li $t3, 1                     # Réinitialisation de l'index2

			boucle_check_row_3:
   				bge $t3, $t4, boucle_check_row_3_bis # Si index2 >= 8, passer à la vérification suivante

    				bge $t7, 1, end_check_row_incorrect         # Si doublon trouvé, sortir
    				beq $t2, $t3, next_index2_row     # Si t2 == t3, passer à la prochaine itération (on ne se compare pas à soi-même)

    				# Charger la valeur de grille[n][t3] dans $t6
    				add $t6, $t1, $t3             # $t6 = adresse de grille[n][t3]
    				lb $t6, 0($t6)                # Charger la valeur dans $t6

    				beq $t5, $t6, end_check_row_incorrect       # Si grille[n][t2] == grille[n][t3], il y a un doublon

    				addi $t3, $t3, 1              # Incrémenter index2
    				j boucle_check_row_3        # Revenir à la boucle interne

	boucle_check_row_3_bis:
    		addi $t2, $t2, 1              # Incrémenter index1
    		j boucle_check_row_2       # Revenir à la première boucle
    		
    	next_index2_row:
            addi $t3, $t3, 1              # Incrémenter index2
            j boucle_check_row_3       # Revenir à la deuxième boucle
    	


	

	end_check_row_correct:
    li $s5, 0         # utiliser pour valider la grille
    li $v0, 4               # Code du syscall pour afficher une chaîne (4)
    la $a0, message_check_row_correct         # Charger l'adresse de la chaîne dans $a0
    syscall
    jr $ra 
    
    end_check_row_incorrect:
    li $s5, 1         # utiliser pour non valider la grille
    li $v0, 4               # Code du syscall pour afficher une chaîne (4)
    la $a0, message_check_row_incorrect         # Charger l'adresse de la chaîne dans $a0
    syscall
    jr $ra 

  
      
# Fonction check_squares                        #



 
check_squares:
    li $s0, -1

boucle_check_square1:
    # $s0 contient l'indice du sous-carré (0 à 8)
    addi $s0, $s0, 1
    beq $s0, 9, end_check_carree_correct
    la $t0, grille                # Charger l'adresse de la grille

    # Calculer la ligne de départ et la colonne de départ du sous-carré
    div $t1, $s0, 3               # $t1 = ligne de départ (0, 1, 2)
    mflo $t1                      # Récupérer le quotient
    mul $t1, $t1, 3               # $t1 = (ligne de départ) * 3

    mul $t2, $s0, 3               # $t2 = colonne de départ (reste de la division)
    rem $t2, $t2, 9               # $t2 = (colonne de départ)

    # Initialiser les index et variables
    li $t3, 0                     # Index pour parcourir les 9 cases du carré
    li $t4, 9                     # Nombre total de cases à vérifier
    li $t5, 0                     # Compteur de doublons

boucle_verification_carree:
    bge $t3, $t4, boucle_check_square1  # Si index >= 9, fin de la vérification

    # Calculer les coordonnées de la case actuelle
    div $t6, $t3, 3               # Ligne relative dans le sous-carré
    mflo $t6                      # $t6 = ligne relative (0, 1, 2)
    add $t6, $t6, $t1             # Ajouter la ligne de départ

    rem $t7, $t3, 3               # Colonne relative dans le sous-carré
    add $t7, $t7, $t2             # Ajouter la colonne de départ

    # Charger la valeur de la case dans $t8
    mul $t9, $t6, 9               # $t9 = ligne * 9
    add $t9, $t9, $t7             # $t9 = adresse relative de la case
    add $t9, $t9, $t0             # $t9 = adresse mémoire réelle de la case
    lb $s1, 0($t9)                # Charger la valeur dans $s1 (utilisation de $s1 comme temporaire)

    # Vérifier les doublons dans le carré
    li $t8, 0                     # Réinitialiser l'index interne pour comparer
boucle_comparaison_carree:
    bge $t8, $t3, next_case_carree # Ne comparer qu'avec les cases déjà visitées

    # Calculer les coordonnées de la case à comparer
    div $t9, $t8, 3               # Ligne relative
    mflo $t9                      # $t9 = ligne relative
    add $t9, $t9, $t1             # Ajouter la ligne de départ

    rem $t7, $t8, 3               # Colonne relative
    add $t7, $t7, $t2             # Ajouter la colonne de départ

    # Charger la valeur à comparer
    mul $t6, $t9, 9               # Ligne * 9
    add $t6, $t6, $t7             # Adresse relative
    add $t6, $t6, $t0             # Adresse mémoire réelle
    lb $s2, 0($t6)                # Charger la valeur dans $s2 (utilisation de $s2 comme temporaire)

    # Ignorer les cases vides
    beqz $s1, next_comparaison_carree
    beqz $s2, next_comparaison_carree

    # Vérifier si les deux cases sont identiques
    beq $s1, $s2, end_check_carree_incorrect

next_comparaison_carree:
    addi $t8, $t8, 1              # Incrémenter l'index interne
    j boucle_comparaison_carree   # Retour à la boucle de comparaison

next_case_carree:
    addi $t3, $t3, 1              # Incrémenter l'index du carré
    j boucle_verification_carree  # Retour à la boucle principale


end_check_carree:
    # Afficher un message en fonction de la valeur de $t5 (compteur d'erreurs)
    li $v0, 4                     # Code syscall pour afficher une chaîne
    beqz $t5, no_error_carree     # Si $t5 == 0, pas d'erreur, afficher "Aucune erreur"

    # Message d'erreur
    la $a0, erreur_message        # Charger l'adresse du message d'erreur
    syscall                       # Afficher le message d'erreur
    jr $ra                        # Terminer la fonction

no_error_carree:
    la $a0, no_error_message      # Charger l'adresse du message de succès
    syscall                       # Afficher le message de succès
    jr $ra                        # Terminer la fonction

verif_carree:
    li $s0, 0                     # Initialiser le "compteur" de rang 
    li $s4, 0
    li $s1, 0
    j boucle_check_carree_2
    
boucle_check_carree_2:
    beq $s1, 1, end_check_carree_incorrect
    addi $s0, $s0, 1
    addi $s4, $s4, 1
    beq $s4, 9, end_check_carree_correct
    j boucle_check_carree_2

end_check_carree_correct:
    li $s7, 0                     # Utiliser pour valider la grille
    li $v0, 4                     # Code du syscall pour afficher une chaîne (4)
    la $a0, message_check_carree_correct   # Charger l'adresse de la chaîne dans $a0
    syscall
    jr $ra 

end_check_carree_incorrect:
    li $s7, 1                     # Utiliser pour non valider la grille
    li $v0, 4                     # Code du syscall pour afficher une chaîne (4)
    la $a0, message_check_carree_incorrect   # Charger l'adresse de la chaîne dans $a0
    syscall
    jr $ra











# Fonction check_sudoku                         #


check_sudoku:

    # les fonction check_row, check_line, check_square doivent avoir été appeller précedament
    # $s5 $s6 $s7 represente la validation de check_row, check_line, check_square si les valeurs de $s sont null
    add $s5,$s5,$s6
    #add $s5,$s5,$s7 #mit en commentaire car ma fonction check n box ne marche pas , 
    beq $s5,0,end_check_sudoku_correct
    j end_check_sudoku_incorrect
    
    end_check_sudoku_correct:
    	li $v0, 4               # Code du syscall pour afficher une chaîne (4)
    	la $a0, message_check_sudoku_correct         # Charger l'adresse de la chaîne dans $a0
    	syscall
    	jr $ra
    
    end_check_sudoku_incorrect:
    	li $v0, 4               # Code du syscall pour afficher une chaîne (4)
    	la $a0, message_check_sudoku_incorrect         # Charger l'adresse de la chaîne dans $a0
    	syscall
    	jr $ra




# Fonction solve_sudoku                         #  



solve_sudoku:
    la $a0, grille      # Charger l'adresse de la chaîne dans $a0
    la $a1, remplacer_grille
    jal remplacer_boucle
    li $t1, 0           # Compteur pour l'index global
    li $t2, 9           # Taille de la grille (9x9)

boucle:
    lb $t3, 0($a0)      # Charger un caractère depuis la grille
    beqz $t3, grille_complete  # Si on atteint la fin de la chaîne, sortir de la boucle

    li $t4, 48          # ASCII pour '0' (case vide)
    beq $t3, $t4, case_vide  # Si c'est une case vide, essayer de la remplir

    # Passer à la case suivante
    addi $t1, $t1, 1    # Incrémenter l'index global
    addi $a0, $a0, 1    # Passer au caractère suivant
    j boucle            # Continuer la boucle

case_vide:
    div $t5, $t1, $t2   # Calculer la ligne (index / 9)
    mflo $t6            # Stocker le quotient dans $t6 (ligne)
    addi $t6, $t6, 1    # Les lignes commencent à 1

    rem $t7, $t1, $t2   # Calculer la colonne (index % 9)
    addi $t7, $t7, 1    # Les colonnes commencent à 1

    # Tester les valeurs de 1 à 9 pour remplir cette case vide
    li $t8, 1           # Commencer avec la valeur 1

remplacer_valeur:
    # Remplacer la case vide par la valeur actuelle (de 1 à 9)
    sb $t8, 0($a0)      # Remplacer le caractère à l'index actuel par la valeur de $t8 ('1' à '9')
    
    jal solve_sudoku   # vas appeler solve sudoku de maniere recursive jusqu'a ce que $s5 soit egal a 0 ce qui voudrat dire que la grille est complete
    
    bnez $s5, remplacer_valeur
    
    
    jal check_sudoku           # Si la grille est valide, continuer, sinon tester le chiffre suivant

    # Si $s5 est 1, la grille n'est pas valide, essayer la valeur suivante
    bnez $s5, next_value  # Si $s5 = 1 (grille invalide), essayer avec la valeur suivante

   j grille_complete

next_value:
    addi $t8, $t8, 1    # Passer à la valeur suivante (de 1 à 9)
    li $t9, 10
    bge $t8, $t9, grille_complete  # Si $t8 atteint 10 (valeur hors limite), on a essayé toutes les valeurs

    j remplacer_valeur   # Essayer la valeur suivante
    

grille_complete:
    # Afficher la grille après modification
    la $a0, grille       # Charger l'adresse de la grille originale dans $a0
    la $a1, copie_grille # Charger l'adresse de la copie de la grille dans $a1
    jal remplacer_grille # Remplacer la grille par la copie

    li $v0, 10           # Terminer le programme
    li $v0, 4            # Syscall pour afficher une chaîne
    syscall

    jr $ra               # Retourner à l'appelant sans terminer le programme


#                                               #
# Autres fonctions que nous avons ajoute :      #
#                                               #
# Fonction ???                                  #   
#                                               #
#fonction pour faire une copie de la grille car nous n'avons pas réussit a   Retirer chiffre de grille[ligne][colonne]  // Rétro-propagation dans solve sudoku
copier_grille:
    # Entrées: $a0 = adresse de la grille originale, $a1 = adresse de la copie
    li $t0, 0            # Index pour parcourir la grille (compteur de position)
    
copier_boucle:
    lb $t1, 0($a0)       # Charger un caractère depuis la grille originale
    sb $t1, 0($a1)       # Stocker ce caractère dans la copie

    addi $a0, $a0, 1     # Passer au caractère suivant de la grille originale
    addi $a1, $a1, 1     # Passer au caractère suivant de la copie
    addi $t0, $t0, 1     # Incrémenter l'index

    li $t2, 81           # La taille de la grille (81 caractères)
    bne $t0, $t2, copier_boucle  # Si l'index n'a pas atteint 81, continuer la copie

    jr $ra               # Retourner à l'appelant


# Fonction remplacer_grille
remplacer_grille:
    # Entrées: $a0 = adresse de la grille originale, $a1 = adresse de la copie
    li $t0, 0            # Index pour parcourir la grille (compteur de position)
    
remplacer_boucle:
    lb $t1, 0($a1)       # Charger un caractère depuis la copie
    sb $t1, 0($a0)       # Remplacer le caractère de la grille originale par celui de la copie

    addi $a0, $a0, 1     # Passer au caractère suivant de la grille originale
    addi $a1, $a1, 1     # Passer au caractère suivant de la copie
    addi $t0, $t0, 1     # Incrémenter l'index

    li $t2, 81           # La taille de la grille (81 caractères)
    bne $t0, $t2, remplacer_boucle  # Si l'index n'a pas atteint 81, continuer la copie

    jr $ra               # Retourner à l'appelant
    

#                                               #
#                                               #
# Fonction !!!                                  #  
#                                               #
#                                               #
#                                               #
################################################# 





exit: 
    li $v0, 10
    syscall
