* TINY Compilation to TM Code
* Standard prelude:
  0:    LD 5,0(0)	Load global pointer
  1:   LDA 6,0(5)	Copy GP to FP
  2:    ST 0,0(0)	Clear location 0
  3:   LDC 7,4(0)	Jump to end of prelude
* End of standard prelude.
* LOAD: loading constant
  4:   LDC 0,0(0)	Load constant value into AC
* ASSIGN: storing value
  5:    ST 0,0(5)	Store result to variable
* WHILE: loop start
* LOAD: loading variable
  6:    LD 0,0(5)	Load variable value into AC
* LOAD: loading constant
  7:   LDC 0,10(0)	Load constant value into AC
* RELOP: comparing values
  8:    ST 0,0(5)	Store left operand
  9:    LD 1,0(5)	Load left operand into AC1
 10:   SUB 0,1,0	Compare by subtraction (L-R)
* WHILE: test condition
* LOAD: loading variable
 12:    LD 0,0(5)	Load variable value into AC
* LOAD: loading constant
 13:   LDC 0,1(0)	Load constant value into AC
* OP: combining values
 14:    ST 0,0(5)	Store left operand
 15:    LD 1,0(5)	Load left operand into AC1
 16:   ADD 0,1,0	Op +
* ASSIGN: storing value
 17:    ST 0,0(5)	Store result to variable
* WHILE: end of loop body
 18:   LDC 7,6(0)	Jump back to loop start
 11:   JEQ 0,19(0)	Jump out of loop if condition is false
* WHILE: end of loop
 19:  HALT 0,0,0	End of program
