# Define the list of applications to build
APPS=hello_c/hello_c hello_cpp/hello_cpp hello_a_c/hello_a_c hello_a_cpp/hello_a_cpp hello_so_c/hello_so_c hello_so_cpp/hello_so_cpp

# Defines the list of archives to build
ARCHIVES=hello_a/hello.a

# Defines the list of libraries/shared objects to build
LIBS=hello_so/libhello.so

# Overwrite CC to specify the C compiler to use.
CC=gcc
# Overwrite CC_STD to specify the C standard to use, defaults to C17.
CC_STD=c18

# Overwrite CXX to specify the CXX compiler to use.
CXX=g++
# Overwrite CXX_STD to specify the C++ standard to use, defaults to C++17.
CXX_STD=c++20

# Overwrite LD to specify the linker to use, defaults to ld.
LD=gcc

# Overwrite AR to specify the archive utility to use.
AR=ar

# Specify to add additional CFLAGS to every target
ADDITIONAL_CFLAGS:=

# Specify to add additional CXXFLAGS to every target
ADDITIONAL_CXXFLAGS:=

# Specify to add additional LDFLAGS to every target
ADDITIONAL_LDFLAGS:=

all: $(APPS) $(ARCHIVES) $(LIBS)

default: all

include rules.mk
