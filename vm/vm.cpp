#include "common.h"
#include "loading.h"

#include <cmath>
#include <cstdio>
Machine M;

struct DCommand
{
 int op;
 int r1;
 int r2;
};

struct SCommand
{
  int op;
  int imm;
  int r1;
};

bool getType(Command command)
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

void execDCommand (DCommand command, int destAddress)
{
  MemoryCell value;
  switch (command.op)
  {
    case 1: value = M.data [command.r1] + M.data [command.r2]; break;
	case 2: value = M.data [command.r1] - M.data [command.r2]; break;
	case 3: value = M.data [command.r1] * M.data [command.r2]; break;
	case 4: value = M.data [command.r2] == 0.0 ? 0.0 : 
	                M.data [command.r1] / M.data [command.r2]; break;
	case 5: M.outputPorts [command.r1] = command.r2; return;
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

void execSCommand (SCommand command, int destAddress)
{
  int value;
  switch (command.op)
  {
	  case 0: return; // NOP
	  case 1: M.statusRegister = compareValues (M.data[command.r1], 
	                                            0.0,
												command.imm);
	          return; // CMPZ
	  case 2: value = fabs (sqrt (M.data [command.r1])); break; //SQRT
	  case 3: value = M.data [command.r1]; break; //COPY
	  case 4: value = M.inputPorts [command.r1]; break; //INPUT
  }
  M.data [destAddress] = value;
}

void execCommand(Command command)
{
 if (getType (command))
    execSCommand(getSCommand(command), M.instructionCounter);
 else
    execDCommand(getDCommand(command), M.instructionCounter);
	
}

void printOutputPorts()
{
 //TODO: enter the list of ports that are observed
}

void getInputPorts()
{
 //TODO: specify the input stream for ports
}
int main(int argc, char *argv[])
{
  M=load(argv[1]);
  M.instructionCounter=0;
  while (true)
  {
	 getInputPorts();
	 execCommand(M.instructions[M.instructionCounter]);
	 printOutputPorts();
	 if (fabs(M.outputPorts[0])<EPS) return 0;
	 M.instructionCounter++; M.instructionCounter &= ((1 << 15) - 1);
  }
  return 123;
}
