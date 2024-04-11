.data
    matrix1: .space 49  # Reserve space for 7x7 integers (4 bytes each)
    matrix2: .space 49
    rong: .asciiz "O"
    dinh: .asciiz  "X"
    phancach: .ascii "|"
    text2: .asciiz "                             "  
    text3: .asciiz "\n______________                             ______________\n"        
    array1: .space 49
    array2: .space 49
    xuongdong: .asciiz "\n"        
    check: .asciiz "check\n"    
    rbow: .asciiz "\nEnter rbow: "
    khong: .asciiz "0"   
    mot: .asciiz "1"  
    cbow: .asciiz "\nEnter cbow: "
    rstern: .asciiz "\nEnter rstern: "
    cstern: .asciiz "\nEnter cstern: "    
    hit: .asciiz "HIT \n"
    miss: .asciiz "MISS \n"
    att1: .asciiz "\nPlayer 1 attack: "
    att2: .asciiz "\nPlayer 2 attack: "
    error: .asciiz "\nError, please select target again!"
    mov1: .asciiz "\nSelect your target's row: "
    mov2: .asciiz "\nSelect your target's col: "
    hai: .asciiz "2"
    p1: .asciiz "\nPlayer 1 is the winner!"
    p2: .asciiz "\nPlayer 2 is the winner!"
    build1_2: .asciiz "\nFinished building 2x1 boats (player1)"
    build1_3: .asciiz "\nFinished building 3x1 boats (player1)"
    build1_4: .asciiz "\nFinished building 4x1 boats (player1)"
    build2_2: .asciiz "\nFinished building 2x1 boats (player2)"
    build2_3: .asciiz "\nFinished building 3x1 boats (player2)"
    build2_4: .asciiz "\nFinished building 4x1 boats (player2)"
    p1turn: .asciiz "\nIt's player1 turn."
    p2turn: .asciiz "\nIt's player2 turn."
.text

#s1,s2 address 2 cai bang display
#s3, s4 address 2 cai mang luu vi tri cua thuyen
#s5 luu thang nao choi
#-4 luu so thuyen 2, -8 luu so thuyen 3, -12 luu so thuyen 4 cua player 1
#-16 luu so thuyen 2, -20 luu so thuyen 3, -24 luu so thuyen 4 cua player 2
#-28 luu luot choi cua thang nao, 1 la thang 1, 0 la thang 2

    addi $sp, $sp, -40
    
    li $t0, 3
    sw $t0, -4($sp)
    sw $t0, -16($sp)

    li $t0, 2
    sw $t0, -8($sp)
    sw $t0, -20($sp)

    li $t0, 1
    sw $t0, -12($sp)
    sw $t0, -24($sp)

    li $t0, 1
    sw $t0, -28($sp)
    
    li $t0, 0
    sw $t0, -32($sp)
    sw $t0, -36($sp)
    sw $t0, -40($sp)
    

    li $t0,49
    li $t1,0
    la $s3, array1                    
    la $s4, array2
    la  $t2, khong             
    lb  $t3, 0($t2)

    
boat_first_loop:
    bge $t1, $t0, pre_buildtable
    
    
    sb  $t3, 0($s3)
    sb  $t3, 0($s4)
    addi $t1, $t1, 1
    addi $s3, $s3, 1
    addi $s4, $s4, 1
    
    
    j boat_first_loop
    


pre_buildtable:
    li $t0,49
    li $t1,0
    la $s1, matrix1                    # Store the value from $t0 into the matrix at offset 0
    la $s2, matrix2
    la  $t2, rong             
    lb  $t3, 0($t2) 
    
buildtable_loop:
    beq $t1, $t0, end_buildtable_loop 
    sb  $t3,0($s1)
    sb  $t3, 0($s2)
    addi $t1,$t1,1
    addi $s1, $s1,1    
    addi $s2, $s2,1   
    j   buildtable_loop         
    
end_buildtable_loop:
    la $s1, matrix1                   
    la $s2, matrix2  
pre_table_display:
    li $t0, 49
    li $t1, 0
    li $t2, 7
    li $t4, 0
    la $s1, matrix1                   
    la $s2, matrix2 
table_display1:
    beq $t1, $t0, end_display
    beq  $t1, $t2, table_update1
    
    lb $t3, 0($s1)
    move $a0, $t3
    li $v0, 11
    syscall
    
    la $t3, phancach 
    lb $a0, 0($t3)
    syscall
      
    addi $t1, $t1, 1
    addi $s1, $s1, 1


    j table_display1
table_display2:
    beq  $t4, $t2, end_display2
    lb $t3, 0($s2)
    move $a0, $t3
    li $v0, 11
    syscall
    
    la $t3, phancach 
    lb $a0, 0($t3)
    syscall
      
    addi $t4, $t4, 1
    addi $s2, $s2, 1
    j table_display2

end_display2:
    jr  $ra
table_update1:
    li $v0, 4
    la $a0, text2
    syscall
    
    jal table_display2

    addi $t2, $t2, 7
    li $v0,4
    la $a0, text3
    syscall
    j table_display1



end_display:
    li $v0, 4
    la $a0, text2
    syscall
    
    jal table_display2
    
    lw $t0, -40($sp)
    beqz $t0, build_boat2_player1
    
    j process
       
    
build_boat2_player1:
    li $t0, 1
    sw $t0, -40($sp)
 
    
    lw $t5, -4($sp)
    beq $t5, $zero, pre_build_boat3_player1
  
    li $v0,4
    la $a0, rbow
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    li $v0,4
    la $a0, cbow
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    li $v0,4
    la $a0, rstern
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $v0,4
    la $a0, cstern
    syscall
    
    li $v0, 5
    syscall
    move $t3, $v0
    
    li $t8, 7
    
    mul $t6, $t0, $t8
    add $t6, $t6, $t1
    
    mul $t7, $t2, $t8
    add $t7, $t7, $t3
    
    
    
    beq $t0, $t2, build_boat2_player1_1r
    beq $t3, $t1, build_boat2_player1_1c
    #t6, t7 vi tri dau va cuoi cua thuyen
build_boat2_player1_1r:
    la $s3, array1
    add $s3, $s3, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat2_player1_1r_loop:
    bgt  $t6, $t7, end_build_boat2_player1_1r_loop
    lb $t2, 0($s3)
    beq $t2, $t1, fix_build_boat2_player1r
    sb $t1, 0($s3)
    addi $t6, $t6, 1
    addi $s3, $s3, 1
    j build_boat2_player1_1r_loop
    
fix_build_boat2_player1r:
    beq $t8,$t6, build_boat2_player1
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -1
    sb $t1, 0($s3)
    
    addi $t6, $t6, -1
    j fix_build_boat2_player1r
    
end_build_boat2_player1_1r_loop: 
    addi $t5, $t5, -1
    sw $t5, -4($sp)
    j build_boat2_player1
    
    
build_boat2_player1_1c:
    la $s3, array1
    add $s3, $s3, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat2_player1_1c_loop:
    bgt $t6, $t7, end_build_boat2_player1_1c_loop
    lb $t2, 0($s3)
    beq $t2, $t1, fix_build_boat2_player1c
    sb $t1, 0($s3)
    addi $t6, $t6, 7
    addi $s3, $s3, 7
    j build_boat2_player1_1c_loop
    
fix_build_boat2_player1c:
    beq $t8,$t6, build_boat2_player1
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -7
    sb $t1, 0($s3)
    
    addi $t6, $t6, -7
    j fix_build_boat2_player1c
    
end_build_boat2_player1_1c_loop: 
    addi $t5, $t5, -1
    sw $t5, -4($sp)
    j build_boat2_player1

pre_build_boat3_player1:
    li $v0,4
    la $a0, build1_2
    syscall  
            
        
build_boat3_player1:
    lw $t5, -8($sp)
    beq $t5, $zero, pre_build_boat4_player1
  
    li $v0,4
    la $a0, rbow
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    li $v0,4
    la $a0, cbow
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    li $v0,4
    la $a0, rstern
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $v0,4
    la $a0, cstern
    syscall
    
    li $v0, 5
    syscall
    move $t3, $v0
    
    li $t8, 7
    
    mul $t6, $t0, $t8
    add $t6, $t6, $t1
    
    mul $t7, $t2, $t8
    add $t7, $t7, $t3
    
    
    
    beq $t0, $t2, build_boat3_player1_1r
    beq $t3, $t1, build_boat3_player1_1c
    #t6, t7 vi tri dau va cuoi cua thuyen
build_boat3_player1_1r:
    la $s3, array1
    add $s3, $s3, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
    
build_boat3_player1_1r_loop:
    bgt  $t6, $t7, end_build_boat3_player1_1r_loop
    lb $t2, 0($s3)
    beq $t2, $t1, fix_build_boat3_player1r
    sb $t1, 0($s3)
    addi $t6, $t6, 1
    addi $s3, $s3, 1
    j build_boat3_player1_1r_loop
   
fix_build_boat3_player1r:
    beq $t8,$t6, build_boat3_player1
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -1
    sb $t1, 0($s3)
    
    addi $t6, $t6, -1
    j fix_build_boat3_player1r
          
end_build_boat3_player1_1r_loop: 
    addi $t5, $t5, -1
    sw $t5, -8($sp)
    j build_boat3_player1
    
    
build_boat3_player1_1c:
    la $s3, array1
    add $s3, $s3, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
    
build_boat3_player1_1c_loop:
    bgt $t6, $t7, end_build_boat3_player1_1c_loop
    lb $t2, 0($s3)
    beq $t2, $t1, fix_build_boat3_player1c
    sb $t1, 0($s3)
    addi $t6, $t6, 7
    addi $s3, $s3, 7
    j build_boat3_player1_1c_loop
    
fix_build_boat3_player1c:

    beq $t8,$t6, build_boat3_player1
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -7
    sb $t1, 0($s3)
    
    addi $t6, $t6, -7
    j fix_build_boat3_player1c
    
end_build_boat3_player1_1c_loop: 
    addi $t5, $t5, -1
    sw $t5, -8($sp)
    j build_boat3_player1
    
pre_build_boat4_player1:
    li $v0,4
    la $a0, build1_3
    syscall 


build_boat4_player1:
    lw $t5, -12($sp)
    beq $t5, $zero, pre_build_boat2_player2
  
    li $v0,4
    la $a0, rbow
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    li $v0,4
    la $a0, cbow
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    li $v0,4
    la $a0, rstern
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $v0,4
    la $a0, cstern
    syscall
    
    li $v0, 5
    syscall
    move $t3, $v0
    
    li $t8, 7
    
    mul $t6, $t0, $t8
    add $t6, $t6, $t1
    
    mul $t7, $t2, $t8
    add $t7, $t7, $t3
    
    
    
    beq $t0, $t2, build_boat4_player1_1r
    beq $t3, $t1, build_boat4_player1_1c
    #t6, t7 vi tri dau va cuoi cua thuyen
build_boat4_player1_1r:
    la $s3, array1
    add $s3, $s3, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat4_player1_1r_loop:
    bgt  $t6, $t7, end_build_boat4_player1_1r_loop
    lb $t2, 0($s3)
    beq $t2, $t1, fix_build_boat4_player1r
    sb $t1, 0($s3)
    addi $t6, $t6, 1
    addi $s3, $s3, 1
    j build_boat4_player1_1r_loop
    
fix_build_boat4_player1r:
    beq $t8,$t6, build_boat4_player1
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -1
    sb $t1, 0($s3)
    
    addi $t6, $t6, -1
    j fix_build_boat2_player1r
    
end_build_boat4_player1_1r_loop: 
    addi $t5, $t5, -1
    sw $t5, -12($sp)
    j build_boat4_player1
    
    
build_boat4_player1_1c:
    la $s3, array1
    add $s3, $s3, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat4_player1_1c_loop:
    bgt $t6, $t7, end_build_boat4_player1_1c_loop
    lb $t2, 0($s3)
    beq $t2, $t1, fix_build_boat4_player1c
    sb $t1, 0($s3)
    addi $t6, $t6, 7
    addi $s3, $s3, 7
    j build_boat4_player1_1c_loop
    
fix_build_boat4_player1c:
    beq $t8,$t6, build_boat4_player1
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -7
    sb $t1, 0($s3)
    
    addi $t6, $t6, -7
    j fix_build_boat4_player1c
    
end_build_boat4_player1_1c_loop: 
    addi $t5, $t5, -1
    sw $t5, -12($sp)
    j build_boat4_player1

pre_build_boat2_player2:
    li $v0,4
    la $a0, build1_4
    syscall     
            
build_boat2_player2:
    lw $t5, -16($sp)
    beq $t5, $zero, pre_build_boat3_player2
  
    li $v0,4
    la $a0, rbow
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    li $v0,4
    la $a0, cbow
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    li $v0,4
    la $a0, rstern
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $v0,4
    la $a0, cstern
    syscall
    
    li $v0, 5
    syscall
    move $t3, $v0
    
    li $t8, 7
    
    mul $t6, $t0, $t8
    add $t6, $t6, $t1
    
    mul $t7, $t2, $t8
    add $t7, $t7, $t3
    
    
    
    beq $t0, $t2, build_boat2_player2_1r
    beq $t3, $t1, build_boat2_player2_1c
    #t6, t7 vi tri dau va cuoi cua thuyen
build_boat2_player2_1r:
    la $s4, array2
    add $s4, $s4, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat2_player2_1r_loop:
    bgt  $t6, $t7, end_build_boat2_player2_1r_loop
    lb $t2, 0($s4)
    beq $t2, $t1, fix_build_boat2_player2r
    sb $t1, 0($s4)
    addi $t6, $t6, 1
    addi $s4, $s4, 1
    j build_boat2_player2_1r_loop
    
fix_build_boat2_player2r:
    beq $t8,$t6, build_boat2_player2
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -1
    sb $t1, 0($s3)
    
    addi $t6, $t6, -1
    j fix_build_boat2_player2r
    
end_build_boat2_player2_1r_loop: 
    addi $t5, $t5, -1
    sw $t5, -16($sp)
    j build_boat2_player2
    
    
build_boat2_player2_1c:
    la $s4, array2
    add $s4, $s4, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat2_player2_1c_loop:
    bgt $t6, $t7, end_build_boat2_player2_1c_loop
    lb $t2, 0($s4)
    beq $t2, $t1, fix_build_boat2_player2c
    sb $t1, 0($s4)
    addi $t6, $t6, 7
    addi $s4, $s4, 7
    j build_boat2_player2_1c_loop
 
fix_build_boat2_player2c:
    beq $t8,$t6, build_boat2_player1
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -7
    sb $t1, 0($s3)
    
    addi $t6, $t6, -7
    j fix_build_boat2_player2c   
    
    
 
end_build_boat2_player2_1c_loop: 
    addi $t5, $t5, -1
    sw $t5, -16($sp)
    j build_boat2_player2
    
pre_build_boat3_player2:
    li $v0,4
    la $a0, build2_2
    syscall     
        
build_boat3_player2:

    lw $t5, -20($sp)
    beq $t5, $zero, pre_build_boat4_player2
  
    li $v0,4
    la $a0, rbow
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    li $v0,4
    la $a0, cbow
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    li $v0,4
    la $a0, rstern
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $v0,4
    la $a0, cstern
    syscall
    
    li $v0, 5
    syscall
    move $t3, $v0
    
    li $t8, 7
    
    mul $t6, $t0, $t8
    add $t6, $t6, $t1
    
    mul $t7, $t2, $t8
    add $t7, $t7, $t3
    
    
    
    beq $t0, $t2, build_boat3_player2_1r
    beq $t3, $t1, build_boat3_player2_1c
    #t6, t7 vi tri dau va cuoi cua thuyen
build_boat3_player2_1r:
    la $s4, array2
    add $s4, $s4, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat3_player2_1r_loop:
    bgt  $t6, $t7, end_build_boat3_player2_1r_loop
    lb $t2, 0($s4)
    beq $t2, $t1, fix_build_boat3_player2r
    sb $t1, 0($s4)
    addi $t6, $t6, 1
    addi $s4, $s4, 1
    j build_boat3_player2_1r_loop
    
fix_build_boat3_player2r:
    beq $t8,$t6, build_boat3_player2
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -1
    sb $t1, 0($s3)
    
    addi $t6, $t6, -1
    j fix_build_boat3_player2r
    
end_build_boat3_player2_1r_loop: 
    addi $t5, $t5, -1
    sw $t5, -20($sp)
    j build_boat3_player2
    
    
build_boat3_player2_1c:
    la $s4, array2
    add $s4, $s4, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat3_player2_1c_loop:
    bgt $t6, $t7, end_build_boat3_player2_1c_loop
    lb $t2, 0($s4)
    beq $t2, $t1, fix_build_boat3_player2c
    sb $t1, 0($s4)
    addi $t6, $t6, 7
    addi $s4, $s4, 7
    j build_boat3_player2_1c_loop
    
fix_build_boat3_player2c:
    beq $t8,$t6, build_boat3_player2
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -7
    sb $t1, 0($s3)
    
    addi $t6, $t6, -7
    j fix_build_boat3_player2c
    
end_build_boat3_player2_1c_loop: 
    addi $t5, $t5, -1
    sw $t5, -20($sp)
    j build_boat3_player2
    

pre_build_boat4_player2:
    li $v0,4
    la $a0, build2_3
    syscall 

build_boat4_player2:
    lw $t5, -24($sp)
    beq $t5, $zero, pre_process
  
    li $v0,4
    la $a0, rbow
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    li $v0,4
    la $a0, cbow
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    li $v0,4
    la $a0, rstern
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $v0,4
    la $a0, cstern
    syscall
    
    li $v0, 5
    syscall
    move $t3, $v0
    
    li $t8, 7
    
    mul $t6, $t0, $t8
    add $t6, $t6, $t1
    
    mul $t7, $t2, $t8
    add $t7, $t7, $t3
    
    
    
    beq $t0, $t2, build_boat4_player2_1r
    beq $t3, $t1, build_boat4_player2_1c
    #t6, t7 vi tri dau va cuoi cua thuyen
build_boat4_player2_1r:
    la $s4, array2
    add $s4, $s4, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat4_player2_1r_loop:
    bgt  $t6, $t7, end_build_boat4_player2_1r_loop
    lb $t2, 0($s4)
    beq $t2, $t1, fix_build_boat4_player2r
    sb $t1, 0($s4)
    addi $t6, $t6, 1
    addi $s4, $s4, 1
    j build_boat4_player2_1r_loop
    
    
fix_build_boat4_player2r:
    beq $t8,$t6, build_boat4_player2
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -1
    sb $t1, 0($s3)
    
    addi $t6, $t6, -1
    j fix_build_boat4_player2r
    
end_build_boat4_player2_1r_loop: 
    addi $t5, $t5, -1
    sw $t5, -24($sp)
    j build_boat4_player2
    
    
build_boat4_player2_1c:
    la $s4, array2
    add $s4, $s4, $t6
    la $t0, mot
    lb $t1, 0($t0)
    move $t8, $t6
build_boat4_player2_1c_loop:
    bgt $t6, $t7, end_build_boat4_player2_1c_loop
    lb $t2, 0($s4)
    beq $t2, $t1, fix_build_boat4_player2c
    sb $t1, 0($s4)
    addi $t6, $t6, 7
    addi $s4, $s4, 7
    j build_boat4_player2_1c_loop
    
fix_build_boat4_player2c:
    beq $t8,$t6, build_boat4_player2
    
    la $t0, khong
    lb $t1, 0($t0)
    
    addi $s3, $s3, -1
    sb $t1, 0($s3)
    
    addi $t6, $t6, -1
    j fix_build_boat4_player2c
    
end_build_boat4_player2_1c_loop: 
    addi $t5, $t5, -1
    sw $t5, -24($sp)
    j build_boat4_player2
    

pre_process:
    li $v0,4
    la $a0, build2_4
    syscall 
        
    j process

pro:    
    j pre_table_display                    
     
process:
    #-28 luu luot choi cua thang nao, 1 la thang 1, 0 la thang 2
    lw $t0, -32($sp)
    lw $t1, -36($sp)
    
    li $t2, 16
    beq $t0, $t2, p1win
    beq $t0, $t2, p2win
    
    lw $t0, -28($sp)
    
    beqz $t0, player2move  #khi t0=0 thi thang 2 choi
    bnez $t0, player1move  #khi t=1 thi thang 1 choi
    

player1move:
    li $v0, 4
    la $a0, p1turn
    syscall
    
    li $v0, 4
    la $a0, mov1
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    li $v0, 4
    la $a0, mov2
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $t3, 7
    mul $t1, $t1, $t3
    add $t1, $t1, $t2       #t1 la vi tri danh bom  
    la $t0, hai
    lb $t2, 0($t0)
    
    la $t0, mot
    lb $t4, 0($t0)
    
    la $s4, array2
    add $s4, $s4, $t1
    
    lb $t3, 0($s4)
    beq $t2, $t3, wrong_move1 #xet xem vi tri do danh tan cong tu truoc chua 2#
    beq $t4, $t3, hit_move1   #xet xem co danh trung k 1=1
    
    
    li $v0, 4
    la $a0, miss
    syscall
    
    sb $t2, 0($s4)
    
    
    la $s2, matrix2
    add $s2, $s2, $t1
    
    la $t0, dinh
    lb $t5, 0($t0)
    
    sb $t5, 0($s2)
    
    
    li $v0, 0
    sw $v0, -28($sp)
    
    j pro
    #thieu buoc hien thi tren man hinh
    
    
wrong_move1:
    li $v0, 4
    la $a0, error
    syscall
    
    j player1move

hit_move1:
    
    li $v0, 4
    la $a0, hit
    syscall
    
    sb $t2, 0($s4)
    
    la $s2, matrix2
    add $s2, $s2, $t1
    
    la $t0, dinh
    lb $t5, 0($t0)
    
    sb $t5, 0($s2)
    
    lw $v0, -32($sp)
    addi $v0, $v0, 1
    sw $v0, -32($sp)
    
    li $v0, 0
    sw $v0, -28($sp)
    
    j pro
    
    


player2move:
    
    li $v0, 4
    la $a0, p2turn
    syscall
    
    li $v0, 4
    la $a0, mov1
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    li $v0, 4
    la $a0, mov2
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $t3, 7
    mul $t1, $t1, $t3
    add $t1, $t1, $t2
    
    #t1 la vi tri danh bom
    
    la $t0, hai
    lb $t2, 0($t0)
    
    la $t0, mot
    lb $t4, 0($t0)
    
    la $s3, array1
    add $s3, $s3, $t1
    
    lb $t3, 0($s3)
    beq $t2, $t3, wrong_move2 #xet xem vi tri do danh tan cong tu truoc chua 2#
    beq $t4, $t3, hit_move2   #xet xem co danh trung k 1=1
    
    
    li $v0, 4
    la $a0, miss
    syscall
    
    sb $t2, 0($s3)
    
    
    la $s1, matrix1
    add $s1, $s1, $t1
    
    la $t0, dinh
    lb $t5, 0($t0)
    
    sb $t5, 0($s1)
    
    
    li $v0, 1
    sw $v0, -28($sp)
    
    j pro
    #thieu buoc hien thi tren man hinh
    
    
wrong_move2:
    li $v0, 4
    la $a0, error
    syscall
    
    j player2move

hit_move2:
    
    li $v0, 4
    la $a0, hit
    syscall
    
    sb $t2, 0($s3)
    
    la $s1, matrix1
    add $s1, $s1, $t1
    
    la $t0, dinh
    lb $t5, 0($t0)
    
    sb $t5, 0($s1)
    
    lw $v0, -36($sp)
    addi $v0, $v0, 1
    sw $v0, -36($sp)
    
    li $v0, 1
    sw $v0, -28($sp)
    
    #thieu buoc hien thi tren man hinh
    j pro

    

    
p1win:
    li $v0, 4
    la $a0, p1
    syscall
   
    j end
                  
p2win:   
    li $v0, 4
    la $a0, p2
    syscall
   
    j end
  
    
     
end:

    # Exit the program
    li $v0, 10                  # Load the exit syscall number
    syscall                     # Make the syscall

    

    

    
