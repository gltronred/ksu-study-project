#include "common.h"
#include "loading.h"

#include <cmath>

Machine M;

void execCommand(Command command)
{
}
void printOutputPorts()
{
}
void getInputPorts()
{

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
