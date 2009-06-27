#include "common.h"
#include "io.h"

#include <cstdio>
#include <cstring>

void printOutputPorts(int step, Machine& M)
{
  bool flag = true;
  for (int i=0; i<16384; i++)
    if (M.outputPorts[i]!=0.0)
	{
	  if (flag) {printf ("%10d ; ", step); flag=false;} 
	  printf ("port %d : %20.8f ; ", i, M.outputPorts[i]);
    }
  if (!flag) printf("\n");
}

void getInputPort(Machine& M, int portNumber)
{
      double value;
	  scanf("%lf",&value);
      M.inputPorts[portNumber]=value;
}
