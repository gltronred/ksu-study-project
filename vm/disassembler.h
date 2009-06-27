#ifndef _DISASSEMBLER_H_
#define _DISASSEMBLER_H_

#include "common.h"
#include "command.h"
void disAsmProgram (Machine M, bool nopsOmitted);
void printData (Machine M);
void disAsmCommand (Command command);

#endif //_DISASSEMBLER_H_
