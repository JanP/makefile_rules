APPS=hello_c/hello_c hello_cpp/hello_cpp hello_a_c/hello_a_c hello_a_cpp/hello_a_cpp hello_so_c/hello_so_c hello_so_cpp/hello_so_cpp
ARCHIVES=hello_a/hello.a
LIBS=hello_so/libhello.so

default: all

all: $(APPS) $(ARCHIVES) $(LIBS)

include rules.mk
