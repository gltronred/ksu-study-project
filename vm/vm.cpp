#include "common.h"
#include "loading.h"
#include "command.h"
#include "io.h"

#include <cmath>
#include <cstdio>
#include <cstring>

Machine M;

int main(int argc, char *argv[])
{
  M=load(argv[1]);
  M.instructionCounter=0;
  int timer = 0;
  while (true)
  {
	 execCommand(M.instructions[M.instructionCounter],M);
	 printOutputPorts(timer,M);
	 if (fabs(M.outputPorts[0])>EPS) return 0;
	 M.instructionCounter++; M.instructionCounter &= ((1 << 15) - 1);
	 timer++;
  }
  return 123;
}
