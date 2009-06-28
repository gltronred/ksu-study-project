TARGETS=vm
CXXFILES=$(wildcard *.cpp)
HFILES=$(wildcard *.h)
FILES=$(HFILES) $(CXXFILES)
CXXFLAGS=-Wall -Wextra -Wpadded

.PHONY: default clean

default: $(TARGETS)

clean:
	rm -rf $(TARGETS)

vm: $(CXXFILES)

$(CXXFILES): $(HFILES)