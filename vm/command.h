#ifndef _COMMAND_H_
#define _COMMAND_H_

#include "common.h"

struct DCommand
{
 int op;
 int r1;
 int r2;
};

struct SCommand
{
  int op;
  int imm;
  int r1;
};

bool getCommandType(Command command);
void execCommand(Command command, Machine& M);
DCommand getDCommand(Command command);
SCommand getSCommand(Command command);


#endif //_COMMAND_H_
