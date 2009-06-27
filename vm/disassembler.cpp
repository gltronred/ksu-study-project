#include "command.h"
#include <cstdio>
#include <cstring>

char cmpLiterals[][7] = {"CMPGZ", "CMPGEZ", "CMPEZ","CMPLZ","CMPLEZ"};


void disAsmCommand (Command command)
{
  if (getCommandType (command))
  {
    SCommand scommand = getSCommand (command);
	switch (scommand.op)
	{
	  case 0: printf ("NOP\n"); break;
	  case 1: printf ("%s %u\n", cmpLiterals[scommand.imm >> 7], scommand.r1); break;
	  case 2: printf ("SQRT %u\n", scommand.r1); break;
	  case 3: printf ("COPY %u\n", scommand.r1); break; 
	  case 4: printf ("INPUT %u\n", scommand.r1); break;
	}
  }
  else
  {
    DCommand dcommand = getDCommand (command);
	switch (dcommand.op)
	{
	  case 1: printf ("ADD %u %u\n",dcommand.r1,dcommand.r2); break;
	  case 2: printf ("SUB %u %u\n",dcommand.r1,dcommand.r2); break;
	  case 3: printf ("MUL %u %u\n",dcommand.r1,dcommand.r2); break;
	  case 4: printf ("DIV %u %u\n",dcommand.r1,dcommand.r2); break;
	  case 5: printf ("OUTPUT port %u  mem %u\n",dcommand.r1,dcommand.r2); break;
	  case 6: printf ("PHI %u %u\n",dcommand.r1,dcommand.r2); break;			
	
	}  
  }
}

void printData (Machine M)
{
 for (int i=0; i<16384; i++)
  if (M.data[i]!=0.0)
    printf ("%u: %.6f\n", i, M.data[i]);
}

void disAsmProgram (Machine M, bool nopsOmitted)
{
  for (int i = 0; i< 16384; i++)
  {
     if ((nopsOmitted && (M.instructions[i]!=0)) || !nopsOmitted)
	 {
	 printf ("%u: ", i);
     disAsmCommand(M.instructions[i]);
     }
  }
 }

