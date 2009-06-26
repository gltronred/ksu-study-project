#include "common.h"
#include "loading.h"

#include <cstdio>

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
  FILE* fi = fopen(filename, "rb");
  bool ok = !feof(fi);
  int k=1;
  while(ok){
    char s[13];
    for(int i=0;i<12;i++)
      fscanf(fi,"%c",s+i);
    //This is unsafe. Test whether padding is affected
    if(k&1){
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
