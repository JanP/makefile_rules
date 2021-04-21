HELLO_A_C=$(notdir hello_a_c/hello_a_c)

$(HELLO_A_C)_CSRCS=hello_a_c/src/hello_main_a.c

$(HELLO_A_C)_CFLAGS=-Ihello_a/inc
$(HELLO_A_C)_LDFLAGS=hello_a/hello.a

hello_a_c/hello_a_c: hello_a/hello.a
