#include "common.h"
#include "loading.h"
#include "command.h"
#include "io.h"
#include "disassembler.h"

#include <cmath>
#include <cstdio>
#include <cstring>

Machine M;

int main(int argc, char *argv[])
{
  M=load(argv[1]);
  M.instructionCounter=0;
  printData(M);
  for (int timer = 0; timer <4000000; timer++)
  {
	 printf ("%u: ", timer);
	 for (int i=0; i< 16384; i++)
	 {
	  M.instructionCounter = i;
	  if (M.instructions[i]!=0) 
	  {
	   //printf("%u: ",i);
	   //disAsmCommand(M.instructions[i]);
	  }
	  execCommand(M.instructions[i],M);
     }
	 printOutputPorts(timer,M);
	 if (M.outputPorts[0]>0.0) return 0; 
  }
  //disAsmProgram(M, true);
  return 0;
}
