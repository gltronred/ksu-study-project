#include "common.h"
#include "loading.h"
#include "command.h"

#include <cmath>
#include <cstdio>

Machine M;

void printOutputPorts(int step)
{
  printf ("%10d ; ", step); 
  for (int i=0; i<16384; i++)
    if (M.outputPorts[i]!=0.0)
	  printf ("port %d : %20.8f ; ", i, M.outputPorts[i]);
  printf("\n");
}

void getInputPorts()
{
  int port = 0;
  double value = 0.0;
  while(port!=-1){
    scanf("%d",&port);
    if(port!=-1){
      scanf("%lf",&value);
      M.inputPorts[port]=value;
    }
  }
}

int main(int argc, char *argv[])
{
  M=load(argv[1]);
  M.instructionCounter=0;
  int timer = 0;
  while (true)
  {
	 getInputPorts();
	 execCommand(M.instructions[M.instructionCounter],M);
	 printOutputPorts(timer);
	 if (fabs(M.outputPorts[0])<EPS) return 0;
	 M.instructionCounter++; M.instructionCounter &= ((1 << 15) - 1);
	 timer++;
  }
  return 123;
}
