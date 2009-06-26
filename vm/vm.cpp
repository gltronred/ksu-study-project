typedef int Command;
typedef double MemoryCell;
MemoryCell inputPorts[16384];
MemoryCell outputPorts[16384];
MemoryCell data[16384];
Command instructions[16384];
long instructionCounter;
bool statusRegister;
void load(char* filename)
{
}
void execCommand(Command command)
{
}
void printOutputPorts()
{
}
void getInputPorts()
{

}
int main(int argc, char *argv[])
{
  load(argv[1]);
  instructionCounter=0;
  while (true)
  {
	 getInputPorts();
	 execCommand(instructions[instructionCounter]);
	 printOutputPorts();
	 if (outputPorts[0]!=0.0) return 0;
	 instructionCounter++; instructionCounter &= ((1 << 15) - 1);
  }
  return 123;
}
