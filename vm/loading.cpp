#include "common.h"
#include "loading.h"

#include <cstdio>
#include <cstring>

Machine load(char* filename)
{
  Machine M;
  for (int i=0; i<16384; i++)
  {
  M.inputPorts[i]=0.0;  
  M.outputPorts[i]=0.0;  
  M.instructions[i]=0u;
  M.data[i] = 0.0;
  }
  M.statusRegister = false;
  FILE* fi = fopen(filename, "rb");
  bool ok = !feof(fi);
  int k=0;
  unsigned char* buffer = (unsigned char *) &M.data[0];
  fread (buffer,8,1,fi);
  while(ok){
	  k++;
	  if (k&1)
	  {
	     buffer = (unsigned char *) &M.instructions[k-1];
		 fread (buffer,4,1,fi);
		 if (feof(fi)) break;
		 buffer = (unsigned char *) &M.instructions[k];
		 fread (buffer,4,1,fi);
	  }
	  else
	  {
		 buffer = (unsigned char *) &M.data[k-1];
		 fread (buffer,8,1,fi);
		 if (feof(fi)) break;
		 buffer = (unsigned char *) &M.data[k];
		 fread (buffer,8,1,fi);
	  }
    }
  M.programSize=k;
  fclose(fi);
  //scanf("%*d");
  return M;
}
