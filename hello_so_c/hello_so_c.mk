HELLO_SO_C=$(notdir hello_so_c/hello_so_c)

$(HELLO_SO_C)_CSRCS=hello_so_c/src/hello_main_so.c

$(HELLO_SO_C)_CFLAGS=-I./hello_so/inc
$(HELLO_SO_C)_LDFLAGS=-L./hello_so -lhello -lstdc++ -Wl,-rpath=./hello_so

hello_so_c/hello_so_c: hello_so/libhello.so
