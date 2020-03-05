.data
string_hello: .asciiz "\nBonjour et bienvenue dans le programme MIPS bancaire\n"
string_choice: .asciiz "Choisissez un nombre entre 1 et 3 \n"
string_end: .asciiz "\nFin du programme, sortie ...\n"
string_err: .asciiz "Veuillez entrer un nombre entre 1 et 3\n"
.text

generate:

## 
#rien
##

__welcome__:

la $a0 string_hello
li $v0 4
syscall

__globl__:

la $a0 string_choice
li $v0 4
syscall

li $v0 5
syscall

move $t0 $v0 

blt $t0 1 errno
beq $t0 1 generate
beq $t0 2 valid_num
beq $t0 3 end
bgt $t0 3 errno

#############
# CATCH ERR #
#############

errno:

la $a0 string_err
li $v0 4
syscall

b __globl__

valid_num:

li $t0 15 # longueur nombre
li $t1 1 # pair impair

	valid_loop:
	
	beq $t0 1 valid_last_num
	jal randint
	
	beq $t1 1 even
	beq $t1 2 pair
	
	
	valid_sum:
	
	add $t9 $t9 $t2 # on enregistre la somme
	move $a0 $t2
	
	sub $t0 $t0 1 # plus que n-1 nombres
	
	b valid_loop
	
	
		randint:
		
		li $a1 9
		li $v0 42
		syscall 
		
		li $v0 1 
		syscall
		
		move $t2 $a0
		jr $ra
		
			
		even:
		
		mul $t2 $t2 2
		bgt $t2 9 sub_nine
		
		even_end:
		add $t1 $t1 1 # pour faire passer a la position pair
		b valid_sum
		
			sub_nine:
			
			sub $t2 $t2 9
			b even_end
		

		pair:
		
		li $v0 0
		sub $t1 $t1 1 #pour passer a la position impair
		
		b valid_sum
		
		
	valid_last_num:
	
	li $t8 10
	bgt $t9 9 mod10
	
	sub $t9 $t8 $t9 
	move $a0 $t9
	
	li $v0 1 #on affiche le dernier nombre
	syscall
	
	b end
		mod10:
		sub $t9 $t9 10
		b valid_last_num


end:

la $a0 string_end
li $v0 4
syscall

li $v0 10
syscall
