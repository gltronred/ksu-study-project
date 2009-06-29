#include "common.h"
#include "io.h"

#include <cstdio>
#include <cstring>
#include <cmath>

void printOutputPorts(int step, Machine& M)
{

  bool flag = true;
  for (int i=0; i<16384; i++)
    if (M.outputPorts[i]!=0.0L)
	{
	  if (flag) {printf ("%d ; ", step); flag=false;} 
	  printf ("%.6lf ; ", M.outputPorts[i]);
        }
  //double radius = sqrt( M.outputPorts[2]*M.outputPorts[2] + M.outputPorts[3]*M.outputPorts[3] );
  //printf("radius : %.2lf ; ", radius);
  if (!flag) printf("\n");
}

void getInputPort(Machine& M, int portNumber)
{
      MemoryCell value;
	  scanf("%lf",&value);
      M.inputPorts[portNumber]=value;
}
