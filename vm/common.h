#ifndef _COMMON_H_
#define _COMMON_H_

#define EPS 1e-8

typedef unsigned int Command;
typedef double MemoryCell;

typedef struct {
  MemoryCell inputPorts[16384];
  MemoryCell outputPorts[16384];
  MemoryCell data[16384];
  Command instructions[16384];
  long instructionCounter;
  bool statusRegister;
} Machine;

#endif //_COMMON_H_
