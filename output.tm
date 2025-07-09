* Tiny Machine Code Generated on Jul  9 2025
* Standard prelude
  0:  LD 6,0(0)	* Load constant 0
  1:  ST 0,0(0)	* Clear location 0 in data memory
* End of standard prelude
* Tiny Machine Code Generated on Jul  9 2025 (Single Pass with LDC)
  2:  LDC 0,0(0)
  3:  ST  0,0(5)
  4:  LD  0,0(5)
  5:  LDC 1,10(0)
  6:  SUB 0,0,1
  7:  JLT 0,2(7)
  8:  LDC 0,0(0)
  9:  LDA 7,1(7)
 10:  LDC 0,1(0)
 11:  ST  0,1(5)
 12:  LD  0,1(5)
 13:  JEQ  0,7(7)
 14:  LD  0,0(5)
 15:  LDC 1,1(0)
 16:  ADD  0,0,1
 17:  ST  0,2(5)
 18:  LD  0,2(5)
 19:  ST  0,0(5)
 20:  LDA  7,-17(7)
* End of program
 21: HALT 0,0,0
