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
* LOAD: loading constant
  6:   LDC 0,1(0)	Load constant value into AC
* ASSIGN: storing value
  7:    ST 0,1(5)	Store result to variable
* LOAD: loading constant
  8:   LDC 0,2(0)	Load constant value into AC
* ASSIGN: storing value
  9:    ST 0,2(5)	Store result to variable
* WHILE: loop start
* LOAD: loading variable
 10:    LD 0,0(5)	Load variable value into AC
* LOAD: loading constant
 11:   LDC 0,5(0)	Load constant value into AC
* RELOP: comparing values
 12:    ST 0,0(5)	Store left operand
 13:    LD 1,0(5)	Load left operand into AC1
 14:   SUB 0,1,0	Compare by subtraction (L-R)
* WHILE: test condition
* WHILE: loop start
* LOAD: loading variable
 16:    LD 0,1(5)	Load variable value into AC
* LOAD: loading constant
 17:   LDC 0,10(0)	Load constant value into AC
* RELOP: comparing values
 18:    ST 0,0(5)	Store left operand
 19:    LD 1,0(5)	Load left operand into AC1
 20:   SUB 0,1,0	Compare by subtraction (L-R)
* WHILE: test condition
* WHILE: loop start
* LOAD: loading variable
 22:    LD 0,2(5)	Load variable value into AC
* LOAD: loading constant
 23:   LDC 0,15(0)	Load constant value into AC
* RELOP: comparing values
 24:    ST 0,0(5)	Store left operand
 25:    LD 1,0(5)	Load left operand into AC1
 26:   SUB 0,1,0	Compare by subtraction (L-R)
* WHILE: test condition
* LOAD: loading variable
 28:    LD 0,2(5)	Load variable value into AC
* LOAD: loading constant
 29:   LDC 0,1(0)	Load constant value into AC
* OP: combining values
 30:    ST 0,0(5)	Store left operand
 31:    LD 1,0(5)	Load left operand into AC1
 32:   ADD 0,1,0	Op +
* ASSIGN: storing value
 33:    ST 0,2(5)	Store result to variable
* WHILE: end of loop body
 34:   LDC 7,22(0)	Jump back to loop start
 27:   JEQ 0,35(0)	Jump out of loop if condition is false
* WHILE: end of loop
* LOAD: loading variable
 35:    LD 0,1(5)	Load variable value into AC
* LOAD: loading constant
 36:   LDC 0,1(0)	Load constant value into AC
* OP: combining values
 37:    ST 0,0(5)	Store left operand
 38:    LD 1,0(5)	Load left operand into AC1
 39:   ADD 0,1,0	Op +
* ASSIGN: storing value
 40:    ST 0,1(5)	Store result to variable
* WHILE: end of loop body
 41:   LDC 7,16(0)	Jump back to loop start
 21:   JEQ 0,42(0)	Jump out of loop if condition is false
* WHILE: end of loop
* LOAD: loading variable
 42:    LD 0,0(5)	Load variable value into AC
* LOAD: loading constant
 43:   LDC 0,1(0)	Load constant value into AC
* OP: combining values
 44:    ST 0,0(5)	Store left operand
 45:    LD 1,0(5)	Load left operand into AC1
 46:   ADD 0,1,0	Op +
* ASSIGN: storing value
 47:    ST 0,0(5)	Store result to variable
* WHILE: end of loop body
 48:   LDC 7,10(0)	Jump back to loop start
 15:   JEQ 0,49(0)	Jump out of loop if condition is false
* WHILE: end of loop
 49:  HALT 0,0,0	End of program
