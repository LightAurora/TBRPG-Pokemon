#Midy Voong
#CSC 35 Project
#12/09/2022

#EXTRA CREDIT TOTAL: 		 45 Points
#Input Validation: 		 5  Points
#Player has multiple "spells"	 15 Points (Did 3)
#The Attack can miss		 10 Points 
#Who won?			 5  Points
#Player's Character Name	 5  Points
#ASCII Art			 5  Points (Did 1)


#NINTENDO DON'T SUE ME PLEASE!
#I USED DIFFERENT CHARACTER NAMES!



.intel_syntax noprefix
.data

Title:
	.ascii "Welcome to the world of Pokemon\n\0"
Designer:
	.ascii "Coded by Midy Voong\n\n\0"
QTrainers:
	.ascii "How many trainers? \0"
Health:
	.ascii "Health: \0"
Target:
	.ascii "Target: \0"
Attack:
	.ascii "Attack them for \0"
SpaceChar:
	.ascii "\n\0"
Points:
	.ascii " points\n\0"
Flinched:
	.ascii "You flinched!\n\n\0"

AttackMenu:
	.ascii "Move List: \n1. Quick Attack \n2. Scratch \n3. Sleep \n4. Tackle \n\0"

DialogueQuickAttack:
	.ascii "Speedily Attack for \0"
DialogueScratch:
	.ascii "Scratch for \0"

DialogueSleep:
	.ascii "Heal for \0"

AttackMenuQuickAttack:
	.ascii "You will now use Quick Attack! \n\0"
AttackMenuScratch:
	.ascii "You will now use Scratch! \n\0"
AttackMenuSleep:
	.ascii "You will now Sleep! \n\0"
AttackMenuTackle:
	.ascii "You will now Tackle! \n\0"

Winner:
	.ascii " has won this battle! \n\0"


AsciiArt:
	.ascii "             _                              \n"
	.ascii " _ __   ___ | | _____ _ __ ___   ___  _ __  \n"
	.ascii "| '_ \\ / _ \\| |/ / _ \\ '_ ` _ \\ / _ \\| '_ \\ \n"
	.ascii "| |_) | (_) |   <  __/ | | | | | (_) | | | |\n"
	.ascii "| .__/ \\___/|_|\\_\\___|_| |_| |_|\\___/|_| |_|\n"
	.ascii "|_|                                         \n\n\0"





Trainer0:					#Trainer Table (EXTRA CREDIT: Player Character Names) 5 points
	.ascii "Trainer: 0, Ashe Ketchup \n\0"
Trainer1:
	.ascii "Trainer: 1, Misti \n\0"
Trainer2:
        .ascii "Trainer: 2, Rock \n\0"
Trainer3:
        .ascii "Trainer: 3, Garee Birch \n\0"
Trainer4:
        .ascii "Trainer: 4, Professor Birch \n\0"
Trainer5:
        .ascii "Trainer: 5, Gym Leader Cynthia \n\0"
Trainer6:
        .ascii "Trainer: 6, Team Blimp: James \n\0"
Trainer7:
        .ascii "Trainer: 7, Team Blimp: Jesse \n\0"
Trainer8:
        .ascii "Trainer: 8, Team Blimp: Meowth \n\0"
Trainer9:
        .ascii "Trainer: 9, Mewtoo \n\0"

Trainers:
	.quad Trainer0
	.quad Trainer1
	.quad Trainer2
	.quad Trainer3
	.quad Trainer4
	.quad Trainer5 
	.quad Trainer6
	.quad Trainer7
	.quad Trainer8
	.quad Trainer9

HP:						#HP Table
	.quad 0
	.quad 0
	.quad 0
	.quad 0 
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0

.text
.global _start


_start:
	lea rdx, Title				#Print Introduction
	call PrintZString
	lea rdx, Designer
	call PrintZString

	lea rdx, AsciiArt			#Print AsciiArt (EXTRA CREDIT: Ascii Art) 15 points
	call PrintZString
	
	lea rdx, QTrainers
	call PrintZString
	call ScanInt
	sub rdx, 1				#Starts with 0
	mov rcx, rdx				#RCX will be the number of players
	lea rdx, SpaceChar
	call PrintZString
	
						#Using RSI to keep track of the Trainer
SettingTrainers:
	cmp rsi, rcx
	jg Reset
	mov rdx, 100
	add [HP + rsi *8], rdx
	add rsi, 1
	jmp SettingTrainers

Reset:
	mov rsi, 0
						
BattleSequence:				
	cmp rcx, 2				
	jl End
	
	mov rdx, [HP + rsi *8]
	cmp rdx, 1
	jl Count

BSTrainerInfo:
	mov rdx, [Trainers + rsi *8]		#Gets Trainers name
	call PrintZString
	
	lea rdx, Health
	call PrintZString
	mov rdx, [HP + rsi *8]			#Gets Trainers HP
	call PrintInt
	lea rdx, SpaceChar
	call PrintZString

BSGetTarget:
	lea rdx, Target				#Gets Target
	call PrintZString
	call ScanInt
	mov rbx, rdx				#RBX holding targets number

	cmp rbx, 0				#Testing for Target Validation Prints message if invalid and skips turn  (EXTRA CREDIT: Input Validation) 5 Points 
	jl PInvalidTarget
	cmp rbx, 9
	jg PInvalidTarget

BSListAttacks:
	lea rdx, AttackMenu			#Printing list of moves (EXTRA CREDIT: Players have multiple "spells" total 3 moves + 1 basic move) 15 Points
	call PrintZString
	call ScanInt
	
	cmp rdx, 1
	je QuickAttack				#(10 dmg) Guranteed 10 dmg
	cmp rdx, 2
	je Scratch				#(1-10 dmg) , chance to attack multiple times
	cmp rdx, 3
	je Sleep				#Heals Anyone (1-20 HP)
						

BSBasicAttack:					#Basic Attack is Tackle (1-20 dmg)
	lea rdx, AttackMenuTackle
	call PrintZString
	mov rdx, 20				#Attacks the Target
	call Random
	add rdx, 1
	mov rax, rdx				#RAX will hold the random number 
	lea rdx, Attack
	call PrintZString
	mov rdx, rax
	call PrintInt
	lea rdx, Points
	call PrintZString

BSBattleDamage:
	sub [HP + rbx *8], rax			#Subtracting the damage 
	lea rdx, SpaceChar
	call PrintZString
	call PrintZString

	
Count:
	add rsi, 1
						#Increments RSI
	cmp rsi, 9				#If RSI is > 9 goes back to 0
	jg Reset

	mov rax, 0				#Reset Values so I can Use
	mov rdi, 0
	mov rcx, 0	
	mov rbx, 0
		
CheckSurvivors:					#Checks how many trainers are alive
	cmp [HP + rdi *8], rax
	jg CountSurvivors

IncrementRBX:
	cmp rdi, 9
	je BattleSequence
	add rdi, 1
	
	jmp CheckSurvivors

CountSurvivors:
	add rcx, 1
	jmp IncrementRBX



PInvalidTarget:
	lea rdx, Flinched          		#Pokemon term when a pokemon misses 
	call PrintZString
	jmp Count


						#POKEMON MOVES STARTS HERE

QuickAttack:					#Quick Attack, Guranteeds 10 dmg
	lea rdx, AttackMenuQuickAttack
	call PrintZString
	mov rax, 10
	lea rdx, DialogueQuickAttack
	call PrintZString
	mov rdx, rax
	call PrintInt
	lea rdx, Points
	call PrintZString
	jmp BSBattleDamage
	
Scratch:					#Scratch, low attack but chance to hit multiple times    (EXTRA CREDIT: Chance to Miss, Theres is a chance to only hit once) 10 Points 
	lea rdx, AttackMenuScratch
	call PrintZString
	mov rdx, 10
	call Random
	add rdx, 1
	mov rax, rdx

	lea rdx, DialogueScratch
	call PrintZString
	mov rdx, rax
	call PrintInt
	lea rdx, Points
	call PrintZString	

ScratchBattleDamage:				#Generates another random number to decide if move will be repeated (50% chance)
	sub [HP +rbx *8], rax
	mov rdx, 10
	call Random
	add rdx, 1
	cmp rdx, 5
	jg Scratch
	lea rdx, SpaceChar
	call PrintZString
	call PrintZString
	jmp Count

Sleep:						#Healing (1-20 HP)
	lea rdx, AttackMenuSleep
	call PrintZString
	mov rdx, 20
	call Random
	add rdx, 1
	mov rax, rdx

	lea rdx, DialogueSleep
	call PrintZString
	mov rdx, rax
	call PrintInt
	lea rdx, Points
	call PrintZString
	lea rdx, SpaceChar
	call PrintZString
	call PrintZString

SleepBattleDamage:
	add [HP +rbx *8], rax
	jmp Count
	



End:
	lea rdx, SpaceChar			#Dictates who wins (EXTRA CREDIT: Who won?) 5 Points
	call PrintZString
	call PrintZString

	mov rdx, [Trainers +rsi *8]
	call PrintZString
	lea rdx, Winner
	call PrintZString
	
	lea rdx, AsciiArt
	call PrintZString
	call Exit
	
	


