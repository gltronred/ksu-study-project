#include "common.h"
#include "io.h"

#include <cstdio>
#include <cstring>

void printOutputPorts(int step, Machine& M)
{
  printf ("%10d ; ", step); 
  for (int i=0; i<16384; i++)
    if (M.outputPorts[i]!=0.0)
	  printf ("port %d : %20.8f ; ", i, M.outputPorts[i]);
  printf("\n");
}

void getInputPorts(Machine& M)
{
  int port = 0;
  double value = 0.0;
  memset(M.inputPorts, sizeof M.inputPorts, 0);
  while(port!=-1){
    scanf("%d",&port);
    if(port!=-1){
      scanf("%lf",&value);
      M.inputPorts[port]=value;
    }
  }
}
