APPS=hello_c/hello_c hello_cpp/hello_cpp hello_a_c/hello_a_c hello_a_cpp/hello_a_cpp hello_so_c/hello_so_c hello_so_cpp/hello_so_cpp
ARCHIVES=hello_a/hello.a
LIBS=hello_so/libhello.so

WARNINGS:=-Wall -Wextra -Wparentheses

# Default value for the C compiler and C compiler flags
CC=gcc
CFLAGS=$(WARNINGS) -Wstrict-prototypes -std=c18

# Default value for the C++ compiler and C++ compiler flags
CXX=g++
CXXFLAGS=$(WARNINGS) -Weffc++ -std=c++17

# Default value for the linker and the linker flags
LD=gcc
LDFLAGS=

# Default value for the archiver and the archiver flags
AR=ar
ARFLAGS=-cr

# Default build target
default: all

all: $(APPS) $(ARCHIVES) $(LIBS)

include rules.mk
