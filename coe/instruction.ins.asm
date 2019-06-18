li $s0, 0xC2000; // vram
//li $s1, 0xFFFFFF04; // counter
//li $s2, 0xFFFFFF00; // gpio
begin:
	addi $s5, $zero, 0x800;	//s5 store the picture root
	li $t1, 0; // y
	move $t0, $s0; // offset
	li $a0, 0xD0000000;	//a0¥Ê∑≈º¸≈Ãµÿ÷∑£∫0xD0000000
	
	
  
TryRight:
	

    loop1:

    slti $t3, $t1, 480; // t3 = y < 480
    beq $t3, $zero, end1;

    li $t2, 0; //x


    loop2:
        slti $t3, $t2, 640; // t3 = x < 640
        beq $t3, $zero, end2;

        slti $t3, $t1, 90; // t3 = y < 90
        slti $t4, $t2, 90; // t4 = x < 90
	
        and $t5, $t3, $t4; // t5 = t3 && t4
	beq $t5, $zero, blue;
	add $t6, $zero, $s5
	add $s7, $zero, $t1;
	add $s7, $s7, $s7;
	add $s7, $s7, $s7;
	add $s7, $s7, $s7;
	add $t6, $t6, $s7; //+8y
	 
	add $s7, $s7, $s7;
	add $s7, $s7, $s7;
	add $t6, $t6, $s7; //+32y
	 
	add $s7, $s7, $s7;
	add $t6, $t6, $s7; //+64y

	add $s7, $s7, $s7;
	add $s7, $s7, $s7;
	add $t6, $t6, $s7; //+256y

	add $s7, $zero, $t2;
	add $s7, $s7, $s7;
	add $s7, $s7, $s7;
	add $t6, $t6, $s7; 
	lw $a1, 0($t6);
	j exit;

      blue:
	   addiu $a1, $zero, 0b1111;

      exit:
	   lw $t7, 0($t0);
	   andi $t7, $t7, 0xFFFF;
	   slo $a1;
	   slo $a1;
	   slo $a1;
	   slo $a1;
	   add $a1, $a1, $t7;
	   sw $a1, 0($t0);
	   //sh $a1, 0($t0);
      addi $t0, $t0, 2 // offset += 2
      addi $t2, $t2, 1; // x++
      j loop2;
    end2:
      addi $t1, $t1, 1; // y++
      j loop1;
  end1:
    j begin;