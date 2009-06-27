#include "common.h"
#include "loading.h"

#include <cstdio>
#include <cstring>
typedef struct {
  double data;
  int code;
} Even;

typedef struct {
  int code;
  double data;
} Odd;

Machine load(char* filename)
{
  Machine M;
  memset(M.inputPorts, sizeof(M.inputPorts),0);  
  memset(M.outputPorts, sizeof(M.outputPorts),0);  
  memset(M.data, sizeof(M.data),0);  
  memset(M.instructions, sizeof(M.instructions),0);
  M.statusRegister = false;
  FILE* fi = fopen(filename, "rb");
  bool ok = !feof(fi);
  int k=1;
  while(ok){
    char s[12];
    for(int i=0;i<12;i++)
      s[i]=fgetc(fi);
	  
    //This is unsafe. Test whether padding is affected
    if((k&1)==1){
      Odd*x=(Odd*)s;
      M.instructions[k-1]=x->code;
      M.data[k-1]=x->data;
    }else{
      Even*x=(Even*)s;
      M.instructions[k-1]=x->code;
      M.data[k-1]=x->data;
    }
    ok=!feof(fi);
    k++;
  }
  fclose(fi);
  return M;
}
