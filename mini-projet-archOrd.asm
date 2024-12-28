.text

.globl main

main: 

la $a0, menuPrompt # Loading menuPrompt str var to reg
li $v0, 4          # print menuPrompt
syscall

li $v0, 5         # read int by the user
syscall
move $t0, $v0     # Storing the int to $t0

# Branching based on the choice that the user input

beq $t0, 1, empList	# List employees
beq $t0, 2, empSearch	# Search employee by id
beq $t0, 3, salMinMax   # Print min max salary
beq $t0, 4, salAvg	# Print average salary
beq $t0, 5, salAbvAvg	# Print nbr of employees with above average salary
beq $t0, 6, payrollTotal # Print total of the company payroll 
beq $t0, 7, programExit	# Exiting program

j main # Jump to main

# Print 
empList:
 lw $t0, nbrEmp   # Load the number of employees to $t1 reg
 li $t1, 0	  # Setting a counter
 la $t2, ids 	  # Load employee names to $t3
 la $t3, namesEmp  # Load employee ids
 la $t4, salaries # Load employee wages
 # Print header
 la $a0, headerEmpList
 li $v0, 4
 syscall

empListLoop:
 bge $t1, $t0 main
# Print id
lw $a0, 0($t2)
li $v0, 1
syscall
# Print blank space
li $a0, 0x20
li $v0, 11
syscall
# Print name
 lw $t5, 0($t3) # Load the address of the current str into $t3
 move $a0, $t5 # Load the str address into $a0
 li $v0, 4
 syscall
 # Print blank space
li $a0, 0x20
li $v0, 11
syscall
# Print employee wage
 lw $a0, 0($t4)
 li $v0, 1
 syscall
 # Print Newline
 la $a0, newline
 li $v0, 4
 syscall
 
 addi $t1, $t1, 1 # $t1 counter++
 addi $t2, $t2, 4 # Move to next id 
 addi $t3, $t3, 4 # Move to next name pointer
 addi $t4, $t4, 4 # Move to next wage  
 
 j empListLoop # Jump 
 
 
 
 # 2nd Functionality employee search by id
empSearch:
# Print the header
la $a0, headerEmpSearch
li $v0, 4
syscall

li $v0, 5 # Read user input
syscall
move $t1, $v0 # Move user input to $t1

lw $t2, nbrEmp # Load nbr of employee to $t2
li $t3, 0      # set counter $t3 to 0 

empSearchLoop:
bge $t3, $t2, searchNotFound
la $t4, ids

mul $t5, $t3, 4
add $t4, $t4, $t5
lw $t6, 0($t4)

beq $t6, $t1, searchFound
addi $t3, $t3, 1
j empSearchLoop

searchNotFound:
la $a0, notFoundMsg
li $v0, 4
syscall
j main

searchFound:
la $a0, foundMsg
li $v0, 4
syscall

# Print employee id
lw $a0, 0($t4) # load matched id into $a0
li $v0, 1
syscall

# Print blank space
li $a0, 0x20
li $v0, 11
syscall

# Print name employee
la $t7, namesEmp  # Load namesEmp pointer array
mul $t5, $t3, 4   # Counter mult by 4 for indexing
add $t7, $t7, $t5 # Compute the adress of the current name pointer
lw $t8, 0($t7)	  # Load the pointer to the employee's name 
la $a0, 0($t8) 	  # Load name into $a0 
li $v0, 4         # Print the name
syscall

# Print blank space
li $a0, 0x20
li $v0, 11
syscall

# Print employee wage
la $t9, salaries  # Load base address of the salaries array
mul $t5, $t3, 4   # Counter mult by 4 for indexing
add $t9, $t9, $t5 # Compute the address of the current salaries array
lw $a0, 0($t9)    # Load matched salary into $a0
li $v0, 1	  # print salary
syscall

# Print newline
la $a0, newline
li $v0, 4
syscall 

j main

# 3nd functionnality computing and printing min and max wage

salMinMax:

lw $t1, nbrEmp   # Load number of employees
la $t2, salaries # Load salaries array
lw $t3, 0($t2)   # Initialize min/max 

move $t4, $t3  # min = $t4
move $t5, $t3  # max = $t5
li $t6, 0      # set loop counter to 0 

salMinMaxLoop:

bge $t6, $t1, printMinMax # After computing proceed to printMinMax
lw $t3, 0($t2) 		# Load current wage

blt $t3, $t4, updateMin 	# if current wage < min, update min
bgt $t3, $t5, updateMax		# if current wage > max, update max

addi $t6, $t6, 1  #  Incrementation++
addi $t2, $t2, 4  #  Move to next wage in salaries array
j salMinMaxLoop
# Update min 
updateMin:
move $t4, $t3
j salMinMaxLoop
# update max
updateMax:
move $t5, $t3
j salMinMaxLoop
# Print min max
printMinMax:
# Print salMinMsg
la $a0, salMinMsg
li $v0, 4
syscall
# Print minimum wage
move $a0, $t4
li $v0, 1
syscall
# Print salMaxMsg
la $a0, salMaxMsg
li $v0, 4
syscall
# Print maximum wage
move $a0, $t5
li $v0, 1
syscall
# Print Newline

la $a0, newline
li $v0, 4
syscall

j main # Jump back to main after execution.

# 4th functionality computing the average salary.

salAvg:
lw $t1, nbrEmp  # Loading number of employees
la $t2, salaries # Loading salaries array
li $t3, 0       # set sum of wages to 0
li $t4, 0       # set counter to 0

salAvgLoop:
bge $t4, $t1, salAvgCal # After computing the sum go to salAvgCal label
lw $t5, 0($t2)          # Load salary 
add $t3, $t3, $t5   	# add the salary to the sum

addi $t4, $t4, 1  # Incrementation++
addi $t2, $t2, 4  # Move to next salary in array
j salAvgLoop

salAvgCal:
la $a0, salAvgMsg # Print salAvgMsg
li $v0, 4
syscall

div $t3, $t1 # Divide sum by nbrEmp ( 6 )
mflo $a0     # Move result to $a0
li $v0, 1    # Print avg wage
syscall
# Print newline
la $a0, newline
li $v0, 4
syscall

j main

# 5th functionnality: Calculate and print number of employees with abv avg wage
# Reused code from the 4th functionality 

# 5th functionality: Calculate and print number of employees with above average salary
salAbvAvg:
lw $t1, nbrEmp
la $t2, salaries
li $t3, 0
li $t4, 0

salAbvAvgLoop:
bge $t4, $t1, avgSal
lw $t5, 0($t2)          # Load salary 
add $t3, $t3, $t5   	# add the salary to the sum
addi $t4, $t4, 1        # Incrementation++
addi $t2, $t2, 4        # Move to next salary in array
j salAbvAvgLoop

avgSal:
div $t3, $t1 # Divide sum by nbrEmp ( 6 )
mflo $t6     # Move avg wage to $t6
# Resetting for second loop
li $t7, 0         # initialize emp counter ( employee with abv avg wage )
la $t2, salaries  # reload salaries array
li $t4, 0         # reset counter for 2nd loop

avgSalLoop:
bge $t4, $t1, avgSalPrint  # After doing the wage comparison proceed to avgSalPrint
lw $t5, 0($t2)  	       # Load current wage
ble $t5, $t6, nextSal   # If wage <= avg, don't increment and go to next salary 
addi $t7, $t7, 1           # If wage >= avg, increment 

nextSal:
addi $t4, $t4, 1  # increment loop counter
addi $t2, $t2, 4  # move to next salary
j avgSalLoop

avgSalPrint:
la $a0, abvAvgSalMsg # Print abvAvgSalMsg 
li $v0, 4
syscall

move $a0, $t7 # move emp count with abv avg wage to $a0
li $v0, 1
syscall
# Print newline
la $a0, newline
li $v0, 4
syscall


j main

# 6th functionnality: Sum of the company's payroll

payrollTotal:
lw $t1, nbrEmp   # Load number of employees
la $t2, salaries # Load salaries array
li $t3, 0        # Sum of salaries set to 0
li $t4, 0 	 # set loop counter to 0

payrollTotalLoop:
bge $t4, $t1, totalPrint
lw $t5, 0($t2)
add $t3, $t3, $t5
addi $t4, $t4, 1
addi $t2, $t2, 4
j payrollTotalLoop

totalPrint:
# Payroll total print
la $a0, totalPrintMsg
li $v0, 4
syscall
# Payroll total
move $a0, $t3 # Move total of salaries to $a0
li $v0, 1
syscall
# Print Newline
la $a0, newline
li $v0, 4
syscall

j main # Back to main

# 7th functionnality : exiting program

programExit:
la $a0, exitMsg # Print message
li $v0, 4
syscall

li $v0, 10 # Exiting the program
syscall

.data
# Employee data
ids: .word 100, 101, 102, 103, 104, 105
# Array of strings
name1: .asciiz "Steve"
name2: .asciiz "Alex"
name3: .asciiz "Adam"
name4: .asciiz "Linus"
name5: .asciiz "Marie"
name6: .asciiz "Christine"

# Array of pointers 
namesEmp: .word name1, name2, name3, name4, name5, name6
salaries: .word 4000, 3000, 5000, 7000, 7500, 10000 
nbrEmp: .word 6 # Number of employees

# Prompt variables
menuPrompt:   .asciiz "\nMini Projet MIPS: Gestion Simplifiee d'une entreprise\n1. Afficher la liste des employees\n2. Rechercher employe\n3. Salaire Min et Max\n4. Salaire Moyen\n5. Nombre d'employe ayant un salaire superieur au salaire moyen\n6. Masse Salariale\n7. Quitter\nEntrer un nombre: "

## Menu Prompt:
### 1. List employees.
### 2. Search employee via id ( integer ).
### 3. Printing in the terminal max and min salary.
### 4. Printing the average salary in the terminal.
### 5. Printing nbr of employees which salary is > than the avg.
### 6. Printing the sum of the companies payroll.
### 7. Quitting the terminal.

# Other prompts variables 
inputIdPrompt: .asciiz "Entrer l'identifiant: "
newline: .asciiz "\n"
headerEmpList: .asciiz "\nListe des employes:\n\nid  nom  salaire\n"
headerEmpSearch: .asciiz "\nRechercher un employe par identifiant\n Entrer un id (100-105)"
notFoundMsg: .asciiz "Employe non trouve :( "
foundMsg: .asciiz "\nResultat:\n id nom salaire\n"
salMinMsg: .asciiz "\nSalaire Minimum: "
salMaxMsg: .asciiz "\nSalaire Maximum: "
salAvgMsg: .asciiz "\nSalaire Moyen: "
abvAvgSalMsg: .asciiz "\nNombre d'employe ayant un salaire superieur au salaire moyen: "
totalPrintMsg: .asciiz "\nTotal de la masse salariale de l'entreprise "
exitMsg: .asciiz "\n Merci d'avoir utiliser ce logiciel de gestion d'entreprise :D. Bye! \n\n\n Mini Projet MIPS fait par Iliass AZIZ\n"

