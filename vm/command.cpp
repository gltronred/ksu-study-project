
#include "command.h"
#include "common.h"
#include "io.h"

#include <cmath>
#include <cstdio>

bool getCommandType(Command command)
{
  int value = 0xf0000000 & command;
  return (value==0);
}

DCommand getDCommand(Command command)
{
 DCommand result;
 result.op = (0xf0000000 & command) >> 28;
 result.r2 = (0x00003fff & command);
 result.r1 = ((0xf0000000 & command) ^ command) >> 14;
 
 return result;
}

void execDCommand (DCommand command, int destAddress, Machine& M)
{
  MemoryCell value;
  switch (command.op)
  {
    case 1: value = M.data [command.r1] + M.data [command.r2]; break;
	case 2: value = M.data [command.r1] - M.data [command.r2]; break;
	case 3: value = M.data [command.r1] * M.data [command.r2]; break;
	case 4: value = M.data [command.r2] == 0.0 ? 0.0 : 
	                M.data [command.r1] / M.data [command.r2]; break;
	case 5: M.outputPorts [command.r1] = M.data[command.r2]; return;
	case 6: value = M.statusRegister ? M.data [command.r1] : 
                                       M.data [command.r2];	 break;			
	default: return;
  }
  M.data [destAddress] = value;
}

SCommand getSCommand (Command command)
{
 SCommand result;
 result.op = command >> 24;
 result.r1 = command & 0x00003fff;
 result.imm = (command ^ (command & 0xff000000)) >> 14;
 return result;
}

bool compareValues (MemoryCell r1, MemoryCell r2, int opcode)
{
  bool result;
  switch (opcode) 
   {
     case 0: result = r1 < r2;  break;
	 case 1: result = r1 <= r2; break;
	 case 2: result = r1 == r2; break;
	 case 3: result = r1 >= r2; break;
	 case 4: result = r1 > r2;  break;
   }
  return result; 
}

void execSCommand (SCommand command, int destAddress, Machine& M)
{
  int value;
  switch (command.op)
  {
	  case 0: return; // NOP
	  case 1: M.statusRegister = compareValues (M.data[command.r1], 
	                                            0.0,
												command.imm >> 7);
	          return; // CMPZ
	  case 2: value = fabs (sqrt (M.data [command.r1])); break; //SQRT
	  case 3: value = M.data [command.r1]; break; //COPY
	  case 4: getInputPorts(M); value = M.inputPorts [command.r1]; break; //INPUT
  }
  M.data [destAddress] = value;
}

void execCommand(Command command, Machine& M)
{
 if (getCommandType (command))
   execSCommand(getSCommand(command), M.instructionCounter, M);
 else
   execDCommand(getDCommand(command), M.instructionCounter, M);
}	


